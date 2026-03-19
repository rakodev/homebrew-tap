cask "macclipboard" do
  version "0.1.9"
  sha256 "a2138007b2798b33215a544bfba76262667a64d05af3b7c580d12c045f7c730a"

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
