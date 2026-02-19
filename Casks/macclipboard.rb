cask "macclipboard" do
  version "0.1.6"
  sha256 "142f765f98a17c4e48e7e38f250735d7f402241191b84b4ff999f28b1326796f"

  url "https://github.com/rakodev/mac-clipboard/releases/download/v#{version}/MacClipboard-Installer.dmg"
  name "MacClipboard"
  desc "Clipboard history manager for macOS"
  homepage "https://github.com/rakodev/mac-clipboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  # Quit app before upgrading (signal as fallback for accessory apps)
  uninstall quit:   "com.macclipboard.app",
            signal: ["TERM", "com.macclipboard.app"]

  app "MacClipboard.app"

  # Always relaunch after install/upgrade.
  # Guard against stale in-memory old process that may survive quit stanza.
  postflight do
    system_command "/bin/sh",
                   args: [
                     "-c",
                     "if /usr/bin/pgrep -x 'MacClipboard' >/dev/null 2>&1; then " \
                     "/usr/bin/pkill -TERM -x 'MacClipboard' >/dev/null 2>&1 || true; " \
                     "/bin/sleep 1; " \
                     "fi",
                   ],
                   must_succeed: false

    system_command "/usr/bin/open",
                   args: ["-a", "MacClipboard"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Preferences/com.macclipboard.app.plist",
    "~/Library/Caches/com.macclipboard.app",
  ]
end
