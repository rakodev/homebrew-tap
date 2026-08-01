cask "macclipboard" do
  version "0.1.13"
  sha256 "bbc28823fe19d1957d9fac93380162aa8a12a4418e7f70c2c16df0ccffdd1048"

  url "https://github.com/rakodev/mac-clipboard/releases/download/v#{version}/MacClipboard-Installer.dmg"
  name "MacClipboard"
  desc "Clipboard history manager for macOS"
  homepage "https://github.com/rakodev/mac-clipboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "MacClipboard.app"

  # Launch app after install/upgrade
  postflight do
    system_command "/usr/bin/open",
                   args:         ["-a", "/Applications/MacClipboard.app"],
                   must_succeed: false
  end

  # Quit app before upgrading (signal only — quit uses AppleScript which
  # prints "Unable to find application" on fresh installs)
  uninstall signal: ["TERM", "com.macclipboard.app"]

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Caches/com.macclipboard.app",
    "~/Library/Preferences/com.macclipboard.app.plist",
  ]
end
