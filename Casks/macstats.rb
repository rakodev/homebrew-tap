cask "macstats" do
  version "0.1.4"
  sha256 "7adf3b2083e4b12571536a2e14676774c4a2d0e794a5109650eb31aa4412dfe1"

  url "https://github.com/rakodev/mac-stats/releases/download/v#{version}/MacStats-Installer.dmg"
  name "MacStats"
  desc "System stats for macOS menu bar"
  homepage "https://github.com/rakodev/mac-stats"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  # Quit app before upgrading (signal only — quit uses AppleScript which
  # prints "Unable to find application" on fresh installs)
  uninstall signal: ["TERM", "com.macstats.app"]

  app "MacStats.app"

  # Launch app after install/upgrade
  postflight do
    system_command "/usr/bin/open",
                   args: ["-a", "/Applications/MacStats.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Preferences/com.macstats.app.plist",
    "~/Library/Caches/com.macstats.app",
  ]
end
