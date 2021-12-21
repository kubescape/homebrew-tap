# homebrew-kubescape
Homebrew for Kubescape

## Update homebrew-kubescape release

1. Set URL with the latest version (you must provide a fixed version and not latest)
```
url "https://github.com/armosec/kubescape/releases/download/<version>/kubescape-macos-latest"
```
2. Set the executable hash
```
sha256 "<sha256>"
```

Find the sha256 ->
* Download latest release
    Make sure you have the right location of the latest release (run `whereis kubescape` and then make sure the version is the latest)
* Get the sha256 -> `sha256sum /home/david/.local/bin/kubescape`