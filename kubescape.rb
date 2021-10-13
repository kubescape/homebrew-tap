class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/releases/download/v1.0.117/kubescape-macos-latest"
  sha256 "8574cb24f964adb51223121aed77370f389309d1503fcee041b37894c89b5810"
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
