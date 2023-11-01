class Nettracker < Formula
  desc "Port monitoring tool that proxies traffic between a client and the tunnel"
  homepage "https://github.com/sparta-science/nettracker"
  version "0.0.4"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/sparta-science/nettracker/releases/download/v#{version}/nettracker-darwin-arm64"
    sha256 "4172aceabd7c13700e660a1f79e3b3dea2813a6c10ba4f47aa13caccd12ab12c"
  else
    url "https://github.com/sparta-science/nettracker/releases/download/v#{version}/nettracker-darwin-amd64"
    sha256 "eb6c3422d216844b8672f7a9d1669efa20cdc916b0f5007f3b6795d1d41facd4"
  end

  def install
    bin.install "nettracker-#{Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"}" => "nettracker"
  end

  test do
    assert_match "nettracker version v#{version}", shell_output("#{bin}/nettracker --version")
  end
end
