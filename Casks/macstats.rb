cask "macstats" do
  version "0.1.1"
  sha256 "8c14c8e9bb2331bad74fa7b372ba58f6e518c60415df0196e61f8045ea5c86e8"

  url "https://github.com/rakodev/mac-stats/releases/download/v#{version}/MacStats-Installer.dmg"
  name "MacStats"
  desc "System stats for macOS menu bar"
  homepage "https://github.com/rakodev/mac-stats"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  # Quit app before upgrading (signal as fallback for accessory apps)
  uninstall quit:   "com.macstats.app",
            signal: ["TERM", "com.macstats.app"]

  app "MacStats.app"

  # Always relaunch after install/upgrade.
  # Guard against stale in-memory old process that may survive quit stanza.
  postflight do
    system_command "/bin/sh",
                   args: [
                     "-c",
                     "if /usr/bin/pgrep -x 'MacStats' >/dev/null 2>&1; then " \
                     "/usr/bin/pkill -TERM -x 'MacStats' >/dev/null 2>&1 || true; " \
                     "/bin/sleep 1; " \
                     "fi",
                   ],
                   must_succeed: false

    system_command "/usr/bin/open",
                   args: ["-a", "MacStats"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Preferences/com.macstats.app.plist",
    "~/Library/Caches/com.macstats.app",
  ]
end
