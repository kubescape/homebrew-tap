# homebrew-kubescape
Homebrew for Kubescape

## Update homebrew-kubescape release

1. Set URL with the latest version (you must provide a fixed version and not latest)
```
url "https://github.com/armosec/kubescape/releases/download/<version>/kubescape-macos-latest"
```
2. Set the executable hash
    * Download kubescape-macos-latest:  
        ```
        curl -L https://github.com/armosec/kubescape/releases/latest/download/kubescape-macos-latest -o kubescape-macos-latest
        ```
    * Calculate sha 
        ```
        sha256sum kubescape-macos-latest
        ```
    * Set the executable hash in `kubescape.rb`
        ```
        sha256 "<sha256>"
        ```
 