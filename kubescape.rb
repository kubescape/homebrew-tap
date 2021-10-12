class Kubescape < Formula
  desc "ARMO's kubescape is a tool for testing if Kubernetes is deployed securely"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/releases/download/v1.0.109/kubescape-macos-latest"
  sha256 "7e75f0f1e6026b5d3b2b94fd0ddcd0a3121b96c3af2e65dd002a1fa8b28cbe6b"
  license "Apache-2.0"

  def install
    bin.install "kubescape-macos-latest" =>  "kubescape"

    output = Utils.safe_popen_read(bin/"kubescape", "completion", "bash")
    (bash_completion/"kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "zsh")
    (zsh_completion/"_kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "fish")
    (fish_completion/"kubescape").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubescape version")

    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")
  end
end
