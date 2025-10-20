FROM python:3.11-slim

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Set working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync

# Copy the rest of the application
COPY . /app

# Ensure run.sh is executable
RUN chmod +x /app/run.sh

# Expose the application port
EXPOSE 8000

# Start the application
ENTRYPOINT ["/app/run.sh"]