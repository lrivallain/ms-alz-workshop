document.addEventListener("DOMContentLoaded", function() {
    mermaid.initialize({
        startOnLoad: true,
        theme: 'default',
        themeVariables: {
            primaryColor: '#1976d2',
            primaryTextColor: '#ffffff',
            primaryBorderColor: '#1565c0',
            lineColor: '#1976d2',
            secondaryColor: '#e3f2fd',
            tertiaryColor: '#ffffff'
        },
        flowchart: {
            useMaxWidth: true,
            htmlLabels: true
        },
        gitgraph: {
            theme: 'base'
        }
    });

    // Re-initialize Mermaid when content changes (for SPA-like behavior)
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.addedNodes.length) {
                mermaid.init(undefined, ".mermaid");
            }
        });
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
});