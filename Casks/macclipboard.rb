cask "macclipboard" do
  version "0.1.12"
  sha256 "70c03576b91ad2f1facc11490688575c31e4f1e94fd59f54dd3d280193c9e1f5"

  url "https://github.com/rakodev/mac-clipboard/releases/download/v#{version}/MacClipboard-Installer.dmg"
  name "MacClipboard"
  desc "Clipboard history manager for macOS"
  homepage "https://github.com/rakodev/mac-clipboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  # Quit app before upgrading (signal only — quit uses AppleScript which
  # prints "Unable to find application" on fresh installs)
  uninstall signal: ["TERM", "com.macclipboard.app"]

  app "MacClipboard.app"

  # Launch app after install/upgrade
  postflight do
    system_command "/usr/bin/open",
                   args: ["-a", "/Applications/MacClipboard.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Preferences/com.macclipboard.app.plist",
    "~/Library/Caches/com.macclipboard.app",
  ]
end
