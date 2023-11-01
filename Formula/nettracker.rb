class Nettracker < Formula
  desc "Port monitoring tool that proxies traffic between a client and the tunnel"
  homepage "https://github.com/sparta-science/nettracker"
  version "0.0.5"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/sparta-science/nettracker/releases/download/v#{version}/nettracker-darwin-arm64"
    sha256 "9caea9ed0f117eb492d3b4dff1938debafef5d2caf972d53a64452aa839bd932"
  else
    url "https://github.com/sparta-science/nettracker/releases/download/v#{version}/nettracker-darwin-amd64"
    sha256 "b671d129102d5296f771e40807f3da328eae21d378e5ac396e565be9f3752e53"
  end

  def install
    bin.install "nettracker-#{Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"}" => "nettracker"
  end

  test do
    assert_match "nettracker version v#{version}", shell_output("#{bin}/nettracker --version")
  end
end
