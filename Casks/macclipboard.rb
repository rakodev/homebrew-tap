cask "macclipboard" do
  version "0.1.8"
  sha256 "31badd9e2d7518252f742b187c202cde659c7524317847016f4cee3e4cb01647"

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
