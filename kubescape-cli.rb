class KubescapeCli < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.164.tar.gz"
  sha256 "331f38cc0868737439b409ad73ce34274fc7542b7699ca44a11f6447db15acbb"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ef7dc344edda8dc0cf2cebdf86169a63675fd0fbe08c9e57707add42839a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264415412177372be6ce2e92673a7469115ff6ce6c29a6efec1eb2a733821695"
    sha256 cellar: :any_skip_relocation, monterey:       "b33d66b12dbd461c7038a53fde23f027046ca30efe51bf66407abe96abf5d934"
    sha256 cellar: :any_skip_relocation, big_sur:        "b38436d3d186c443b5deb669ac7be828296618d0f938dd68dc97340517d58f8b"
    sha256 cellar: :any_skip_relocation, catalina:       "520774f9ca98acc82a4f86d2cc36e83684ad411f41bed5c262296647e1787b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f380152c0c592450d46da3f3731853a452de6fe0a2fe824212465711ff6a9d"
  end

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
      -X github.com/armosec/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "make", "libgit2"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "static"

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
