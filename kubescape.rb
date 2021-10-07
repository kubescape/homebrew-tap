class Kubescape < Formula
  desc "ARMO's kubescape is a tool for testing if Kubernetes is deployed securely"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/releases/download/v1.0.99/kubescape-macos-latest"
  sha256 "36703d374c318989700d4dcb0bcf1a3f2090dc202a76374dd69ca02e244a9e35"
  license "Apache-2.0"

  def install
    bin.install "kubescape-macos-latest" =>  "kubescape"
  end

  test do
    system "false"
  end
end
