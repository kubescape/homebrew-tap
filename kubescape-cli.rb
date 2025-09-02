class KubescapeCli < Formula
  desc "Kubernetes misconfiguration testing"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/v3.0.34.tar.gz"
  sha256 "1da5a3a7b1ef8f38569ee6277fa8cf9d747f9fe379c9283011c7464b7c1003de"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  depends_on "go" => :build

  def install

    ENV["GOCACHE"] = buildpath/"cache"

    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]
    
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "static,gitenabled", "-o", bin/"kubescape"

    output = Utils.safe_popen_read(bin/"kubescape", "completion", "bash")
    (bash_completion/"kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "zsh")
    (zsh_completion/"_kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "fish")
    (fish_completion/"kubescape.fish").write output
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
