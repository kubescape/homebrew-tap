class KubescapeCli < Formula
  desc "Kubernetes misconfiguration testing"
  homepage "https://github.com/kubescape/kubescape"
  
  # Fetch latest version from GitHub API
  def self.latest_version_info
    require "net/http"
    require "json"
    
    uri = URI("https://api.github.com/repos/kubescape/kubescape/tags")
    response = Net::HTTP.get_response(uri)
    
    if response.code == "200"
      tags = JSON.parse(response.body)
      version_tag = tags.find { |tag| tag["name"] =~ /^v\d+\.\d+\.\d+$/ }
      if version_tag
        version = version_tag["name"]
        commit_sha = version_tag["commit"]["sha"]
        
        return {
          version: version,
          sha: commit_sha
        }
      end
    end
    
    {
      version: "v3.0.34",
      sha: "1da5a3a7b1ef8f38569ee6277fa8cf9d747f9fe379c9283011c7464b7c1003de"
    }
  end
  
  version_info = latest_version_info
  version_string = version_info[:version].sub(/^v/, "")
  
  url "https://github.com/kubescape/kubescape/archive/v#{version_string}.tar.gz"
  sha256 :no_check
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
