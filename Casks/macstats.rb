cask "macstats" do
  version "0.1.2"
  sha256 "79dfe89c7b1bfad4624c395cc3b596f979c4766a2f4c6f26ca1bc17969adcb73"

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
