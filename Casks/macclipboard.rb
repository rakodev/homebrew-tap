cask "macclipboard" do
  version "0.0.1"
  sha256 "4f06931be780786736e3264edbad73ca75443fa2b6913dfa957bca83a2a2f7b2"

  url "https://github.com/rakodev/mac-clipboard/releases/download/v#{version}/MacClipboard-Installer.dmg"
  name "MacClipboard"
  desc "Clipboard history manager for macOS"
  homepage "https://github.com/rakodev/mac-clipboard"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "MacClipboard.app"

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Preferences/com.macclipboard.MacClipboard.plist",
    "~/Library/Caches/com.macclipboard.MacClipboard",
  ]
end
