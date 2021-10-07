class Kubescape < Formula
  desc "ARMO's kubescape is a tool for testing if Kubernetes is deployed securely"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/releases/download/v1.0.102/kubescape-macos-latest"
  sha256 "ac97ad4efe33bc511da8479b668eb398312025891ed6c1206773bd2106a246ff"
  license "Apache-2.0"

  def install
    bin.install "kubescape-macos-latest" =>  "kubescape"
  end

  test do
    system "false"
  end
end
