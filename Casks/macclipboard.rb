cask "macclipboard" do
  version "0.1.4"
  sha256 "5000b0967931864b7791468341fa1e5a9f7e16739a21116077595e4722406da4"

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
