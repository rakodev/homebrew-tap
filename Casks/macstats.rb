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
