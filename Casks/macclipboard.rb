cask "macclipboard" do
  version "0.0.3"
  sha256 "6859688c27ae2ffe93f4961d1ce26b31d3b4a5d3e314bfe8cc06ea2888cb41bc"

  url "https://github.com/rakodev/mac-clipboard/releases/download/v#{version}/MacClipboard-Installer.dmg"
  name "MacClipboard"
  desc "Clipboard history manager for macOS"
  homepage "https://github.com/rakodev/mac-clipboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  # Quit app before upgrading
  uninstall quit: "com.macclipboard.MacClipboard"

  app "MacClipboard.app"

  # Relaunch after install
  postflight do
    system_command "/usr/bin/open", args: ["-a", "MacClipboard"]
  end

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Preferences/com.macclipboard.MacClipboard.plist",
    "~/Library/Caches/com.macclipboard.MacClipboard",
  ]
end
