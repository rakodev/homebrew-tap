cask "macclipboard" do
  version "0.1.14"
  sha256 "13f6ab342acd2e13ea6fc61b558bfaa63f95b77b3bc4c40a274a01f27f069c9b"

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
