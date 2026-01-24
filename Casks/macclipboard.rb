cask "macclipboard" do
  version "0.0.2"
  sha256 "af09388c3452e85b9854ffd068f3ee2ac8acc56c5f86a7926cb8c9218b08ebfb"

  url "https://github.com/rakodev/mac-clipboard/releases/download/v#{version}/MacClipboard-Installer.dmg"
  name "MacClipboard"
  desc "Clipboard history manager for macOS"
  homepage "https://github.com/rakodev/mac-clipboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "MacClipboard.app"

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Preferences/com.macclipboard.MacClipboard.plist",
    "~/Library/Caches/com.macclipboard.MacClipboard",
  ]
end
