cask "macstats" do
  version "0.1.7"
  sha256 "f599fd3cc4d9e916c787771ca774f2efe1ab5b311b176aacc565b297768ced15"

  url "https://github.com/rakodev/mac-stats/releases/download/v#{version}/MacStats-Installer.dmg"
  name "MacStats"
  desc "System stats for macOS menu bar"
  homepage "https://github.com/rakodev/mac-stats"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "MacStats.app"

  # Launch app after install/upgrade
  postflight do
    system_command "/usr/bin/open",
                   args:         ["-a", "/Applications/MacStats.app"],
                   must_succeed: false
  end

  # Quit app before upgrading (signal only — quit uses AppleScript which
  # prints "Unable to find application" on fresh installs)
  uninstall signal: ["TERM", "com.macstats.app"]

  zap trash: [
    "~/Library/Caches/com.macstats.app",
    "~/Library/Preferences/com.macstats.app.plist",
  ]
end
