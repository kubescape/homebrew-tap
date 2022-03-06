class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  head "https://github.com/armosec/kubescape/releases/latest/download/kubescape-macos-latest"
  url "https://github.com/armosec/kubescape/releases/download/v2.0.149/kubescape-macos-latest"
  sha256 "1c63ccce80981dc86d09625afe3f6aa5dbf3c83628f6652bbea4f44f4588d5b0"
  license "Apache-2.0"

  def install
    system "chmod 555 kubescape-macos-latest"
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
