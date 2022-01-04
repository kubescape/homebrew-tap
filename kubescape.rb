class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  head "https://github.com/armosec/kubescape/releases/latest/download/kubescape-macos-latest"
  url "https://github.com/armosec/kubescape/releases/download/v1.0.137/kubescape-macos-latest"
  sha256 "2f608f8a20763d56769970b7da7e5c76a81178453f280b1f7b598266d4c1aceb"
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
