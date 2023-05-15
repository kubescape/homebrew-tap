class KubescapeCli < Formula
  desc "Kubernetes misconfiguration testing"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/v2.3.2.tar.gz"
  sha256 "5a1c1b9845f80604949257fac2d40d1a3b97e403fc98524e10b11c893f1e0e2e"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build

  resource "git2go" do
    url "https://github.com/libgit2/git2go/archive/refs/tags/v33.0.9.tar.gz"
    sha256 "bcdaa5ed86d7ad513f51cdd80006a23a7fa9d9e68db06b3ce39a25a4196e4d67"
  end

  resource "libgit2" do
    url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.3.0.tar.gz"
    sha256 "192eeff84596ff09efb6b01835a066f2df7cd7985e0991c79595688e6b36444e"
  end

  def install
    resource("git2go").stage(buildpath/"git2go")
    resource("libgit2").stage(buildpath/"git2go/vendor/libgit2")

    ENV["CGO_ENABLED"] = "1"
    ENV["GOCACHE"] = buildpath/"cache"

    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]
    
    system "make", "libgit2"
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
