# Cleanup: Tear Down Resources

## Overview

In this module, you will clean up the resources created during the workshop to avoid unnecessary costs and maintain a tidy environment.

## Steps to Clean Up

### Create and publish a cleanup workflow

1. In your GitHub repository, create a new file under `github/workflows/terraform-destroy.yml`.

    ```yaml
    # .github/workflows/terraform-destroy.yml
    name: 'Terraform Destroy Infrastructure'

    on:
      workflow_dispatch:
        inputs:
          environment:
            description: 'Target environment to destroy'
            required: true
            default: 'dev'
            type: choice
            options:
            - dev
            - prod
          confirmation:
            description: 'Type "DESTROY" to confirm you want to destroy infrastructure'
            required: true
            type: string
          reason:
            description: 'Reason for destroying infrastructure'
            required: true
            type: string

    permissions:
      id-token: write       # Required for OIDC
      contents: read        # Required for checkout
      issues: write         # For posting destruction summary

    env:
      TF_WORKING_DIR: './terraform'

    jobs:
      # Validation job to ensure proper inputs
      validate-inputs:
        runs-on: ubuntu-latest
        outputs:
          environment: ${{ steps.validate.outputs.environment }}
          proceed: ${{ steps.validate.outputs.proceed }}
        steps:
        - name: Validate Inputs
          id: validate
          run: |
            # Check if confirmation matches
            if [ "${{ github.event.inputs.confirmation }}" != "DESTROY" ]; then
              echo "❌ Confirmation must be exactly 'DESTROY'"
              exit 1
            fi

            # Validate environment
            if [[ ! "${{ github.event.inputs.environment }}" =~ ^(dev|prod)$ ]]; then
              echo "❌ Environment must be 'dev' or 'prod'"
              exit 1
            fi

            # Check reason is provided
            if [ -z "${{ github.event.inputs.reason }}" ]; then
              echo "❌ Reason for destruction is required"
              exit 1
            fi

            echo "✅ All inputs validated"
            echo "environment=${{ github.event.inputs.environment }}" >> $GITHUB_OUTPUT
            echo "proceed=true" >> $GITHUB_OUTPUT

        - name: Display Destruction Plan
          run: |
            echo "🚨 INFRASTRUCTURE DESTRUCTION REQUEST"
            echo "Environment: ${{ github.event.inputs.environment }}"
            echo "Requester: ${{ github.actor }}"
            echo "Reason: ${{ github.event.inputs.reason }}"
            echo "Timestamp: $(date)"

            if [ "${{ github.event.inputs.environment }}" = "prod" ]; then
              echo "⚠️  PRODUCTION ENVIRONMENT - MANUAL APPROVAL REQUIRED"
            fi

      # Plan destruction to show what will be destroyed
      plan-destroy:
        needs: validate-inputs
        runs-on: ubuntu-latest
        if: needs.validate-inputs.outputs.proceed == 'true'
        outputs:
          has-resources: ${{ steps.plan.outputs.has-resources }}
        steps:
        - name: Checkout
          uses: actions/checkout@v5

        - name: Setup Terraform and Init
          uses: ./.github/actions/terraform-setup-init
          with:
            azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
            azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
            azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
            working-directory: ${{ env.TF_WORKING_DIR }}
            environment: ${{ github.event.inputs.environment }}
            storage-account-suffix: ${{ vars.RANDOM_SUFFIX }}

        - name: Plan Destruction
          id: plan
          run: |
            echo "Planning destruction for ${{ github.event.inputs.environment }} environment..."

            # Create destroy plan
            terraform plan -destroy \
              -var-file="environments/${{ github.event.inputs.environment }}/terraform.tfvars" \
              -out=destroy-plan.tfout

            # Show the destroy plan
            echo "📋 Resources to be destroyed:"
            terraform show -no-color destroy-plan.tfout | tee destroy-plan-output.txt

            # Check if there are actually resources to destroy
            if grep -q "No changes" destroy-plan-output.txt; then
              echo "ℹ️  No resources found to destroy"
              echo "has-resources=false" >> $GITHUB_OUTPUT
            else
              echo "⚠️  Resources found that will be destroyed"
              echo "has-resources=true" >> $GITHUB_OUTPUT
            fi
          working-directory: ${{ env.TF_WORKING_DIR }}

        - name: Save Destroy Plan as Artifact
          if: steps.plan.outputs.has-resources == 'true'
          uses: actions/upload-artifact@v4
          with:
            name: destroy-plan-${{ github.event.inputs.environment }}
            path: |
              ${{ env.TF_WORKING_DIR }}/destroy-plan.tfout
              ${{ env.TF_WORKING_DIR }}/destroy-plan-output.txt
            retention-days: 1

      # Development environment destruction (auto-approved)
      destroy-dev:
        needs: [validate-inputs, plan-destroy]
        runs-on: ubuntu-latest
        if: |
          needs.validate-inputs.outputs.environment == 'dev' &&
          needs.plan-destroy.outputs.has-resources == 'true'
        environment: development
        steps:
        - name: Checkout
          uses: actions/checkout@v5

        - name: Download Destroy Plan
          uses: actions/download-artifact@v4
          with:
            name: destroy-plan-${{ github.event.inputs.environment }}
            path: ${{ env.TF_WORKING_DIR }}/

        - name: Setup Terraform and Init
          uses: ./.github/actions/terraform-setup-init
          with:
            azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
            azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
            azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
            working-directory: ${{ env.TF_WORKING_DIR }}
            environment: ${{ github.event.inputs.environment }}
            storage-account-suffix: ${{ vars.RANDOM_SUFFIX }}

        - name: Execute Destruction
          run: |
            echo "🚨 Starting DEVELOPMENT infrastructure destruction"
            echo "Requester: ${{ github.actor }}"
            echo "Reason: ${{ github.event.inputs.reason }}"

            # Apply the destroy plan
            terraform apply destroy-plan.tfout

            echo "✅ Development infrastructure destroyed successfully"
          working-directory: ${{ env.TF_WORKING_DIR }}

        - name: Post-destruction validation
          run: |
            echo "🔍 Verifying destruction..."

            # Try to plan again to ensure everything is destroyed
            terraform plan \
              -var-file="environments/${{ github.event.inputs.environment }}/terraform.tfvars" \
              -detailed-exitcode

            if [ $? -eq 0 ]; then
              echo "✅ Destruction verified - no resources remain"
            else
              echo "⚠️  Some resources may still exist - check manually"
            fi
          working-directory: ${{ env.TF_WORKING_DIR }}

      # Production environment destruction (requires manual approval)
      destroy-prod:
        needs: [validate-inputs, plan-destroy]
        runs-on: ubuntu-latest
        if: |
          needs.validate-inputs.outputs.environment == 'prod' &&
          needs.plan-destroy.outputs.has-resources == 'true'
        environment: production
        steps:
        - name: Checkout
          uses: actions/checkout@v5

        - name: Pre-destruction Warning
          run: |
            echo "🚨🚨🚨 PRODUCTION INFRASTRUCTURE DESTRUCTION 🚨🚨🚨"
            echo ""
            echo "⚠️  WARNING: This will destroy ALL PRODUCTION resources!"
            echo "Environment: PRODUCTION"
            echo "Requester: ${{ github.actor }}"
            echo "Approver: ${{ github.triggering_actor }}"
            echo "Reason: ${{ github.event.inputs.reason }}"
            echo "Timestamp: $(date)"
            echo ""
            echo "🔍 Please review the destroy plan carefully before proceeding."

        - name: Download Destroy Plan
          uses: actions/download-artifact@v4
          with:
            name: destroy-plan-${{ github.event.inputs.environment }}
            path: ${{ env.TF_WORKING_DIR }}/

        - name: Setup Terraform and Init
          uses: ./.github/actions/terraform-setup-init
          with:
            azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
            azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
            azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
            working-directory: ${{ env.TF_WORKING_DIR }}
            environment: ${{ github.event.inputs.environment }}
            storage-account-suffix: ${{ vars.RANDOM_SUFFIX }}

        - name: Final Confirmation Check
          run: |
            echo "🔴 FINAL SAFETY CHECK"
            echo "This is your last chance to abort the production destruction."
            echo "The following resources will be PERMANENTLY DELETED:"
            echo ""
            cat destroy-plan-output.txt
            echo ""
            echo "Continuing with destruction in 10 seconds..."
            sleep 10
          working-directory: ${{ env.TF_WORKING_DIR }}

        - name: Execute Production Destruction
          run: |
            echo "🚨 Starting PRODUCTION infrastructure destruction"
            echo "Requester: ${{ github.actor }}"
            echo "Approver: ${{ github.triggering_actor }}"
            echo "Reason: ${{ github.event.inputs.reason }}"

            # Apply the destroy plan
            terraform apply destroy-plan.tfout

            echo "💥 Production infrastructure destroyed"
          working-directory: ${{ env.TF_WORKING_DIR }}

        - name: Post-destruction validation
          run: |
            echo "🔍 Verifying production destruction..."

            # Try to plan again to ensure everything is destroyed
            terraform plan \
              -var-file="environments/${{ github.event.inputs.environment }}/terraform.tfvars" \
              -detailed-exitcode

            if [ $? -eq 0 ]; then
              echo "✅ Production destruction verified - no resources remain"
            else
              echo "⚠️  Some resources may still exist - manual cleanup required"
            fi
          working-directory: ${{ env.TF_WORKING_DIR }}
    ```

2. In a new branch, commit and push the changes to your repository.
3. Create a Pull Request and merge it into the main branch.

### Run the cleanup workflow

1. Once merged, you need to manually trigger the workflow:
    - Go to the "Actions" tab in your GitHub repository.
    - Select the "Terraform Destroy Infrastructure" workflow from the left sidebar.
    - Click on the "Run workflow" button and provide the required inputs:
        - **environment**: Select either `dev` or `prod` depending on which environment you want to destroy.
        - **confirmation**: Type `DESTROY` to confirm you want to proceed with the destruction.
        - **reason**: Provide a reason for destroying the infrastructure.
1. Monitor the workflow run to ensure the destruction completes successfully.
1. Repeat the process for the other environment.

### Verify Cleanup

1. After the workflow completes, verify that all resources have been destroyed:
    - Check your Azure portal to ensure no resources remain in the specified environments.
    - Review the workflow logs for any errors or warnings during the destruction process.

### Additional Cleanup (Optional)

You can cleanup GitHub repository if you do not need it anymore:

1. Go to your repository on GitHub.
1. Click on "Settings" > "Danger Zone" > "Delete this repository".
1. Follow the prompts to confirm deletion.

----

## Workshop Conclusion

🎉 **Congratulations!** You've completed the DevOps Pipelines Implementation workshop!

**Thank you for participating! Questions?** 🤔