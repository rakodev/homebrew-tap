cask "macclipboard" do
  version "0.0.5"
  sha256 "e24644dbf67442c948444034f341cc77011d7e4f3feea22f921fecf4f192e091"

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
