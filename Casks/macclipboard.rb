cask "macclipboard" do
  version "0.1.16"
  sha256 "661c308c9d15b6df60dfbca27317823182caf52edde074e3ed9378ff22bec745"

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
