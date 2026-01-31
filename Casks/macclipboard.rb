cask "macclipboard" do
  version "0.1.2"
  sha256 "8eb52f23f089b3c8906cda55a865df93b59911568fe2d853b00feda17b886a0b"

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
  uninstall quit: "com.macclipboard.app"

  app "MacClipboard.app"

  # Relaunch after install
  postflight do
    system_command "/usr/bin/open", args: ["-a", "MacClipboard"]
  end

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Preferences/com.macclipboard.app.plist",
    "~/Library/Caches/com.macclipboard.app",
  ]
end
