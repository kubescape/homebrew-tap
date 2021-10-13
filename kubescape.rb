class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/releases/download/v1.0.115/kubescape-macos-latest"
  sha256 "75c7b244559a0f6d5491342687d18c9ccc662f9f3eff635a3b610cd9057e699a"
  license "Apache-2.0"

  def install
    bin.install "kubescape-macos-latest" =>  "kubescape"
  end

  test do
    system "false"
  end
end
