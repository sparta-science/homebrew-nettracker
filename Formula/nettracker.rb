class Nettracker < Formula
  desc "Port monitoring tool that proxies traffic between a client and the tunnel"
  homepage "https://github.com/sparta-science/nettracker"
  version "0.0.3"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/sparta-science/nettracker/releases/download/v#{version}/nettracker-darwin-arm64"
    sha256 "5faf65f5979502275bd6379b60f32d65268cea08a24595e4a7f6fcab338cd2db"
  else
    url "https://github.com/sparta-science/nettracker/releases/download/v#{version}/nettracker-darwin-amd64"
    sha256 "436782890448ddbb4ebcf2000b607e6088ea080e2e323118ac87eb0c23726d2f"
  end

  def install
    bin.install "nettracker-#{Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"}" => "nettracker"
  end

  test do
    assert_match "nettracker version v#{version}", shell_output("#{bin}/nettracker --version")
  end
end
