cask "macclipboard" do
  version "0.1.24"
  sha256 "0d789299df3155ef7fba6d4f8acaeaa3ee33d650f045d97d3466e18821c3acd9"

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

  # Start the copy that was just installed.
  #
  # An upgrade replaces the bundle while the app keeps running, and macOS then refuses that
  # process for Accessibility, because the code identity it recorded no longer matches the
  # binary now at its path: auto-paste and the global hotkey stop working while System
  # Settings still shows MacClipboard as enabled. Homebrew is supposed to quit the app before
  # replacing it, but it decides whether the app is running via AppleScript and `launchctl
  # list`, and neither reports a menu bar app started as a login item, so it silently skips
  # it. `open` alone does not help either: with the old process still alive, macOS just
  # activates that one instead of launching the new bundle. So end the old process first, by
  # its executable path, which is the release copy and never a dev build.
  #
  # This runs from the *new* cask, so it fixes the upgrade for everyone already on an older
  # version. From 0.1.17 on the app also notices this itself and restarts.
  postflight do
    executable = "/Applications/MacClipboard.app/Contents/MacOS/MacClipboard"

    system_command "/usr/bin/pkill",
                   args:         ["-f", executable],
                   must_succeed: false

    # Wait for it to actually be gone before launching, rather than guessing at a sleep: the
    # app handles SIGTERM by shutting down in order, and `open` while it is still alive would
    # activate the very process we are replacing.
    20.times do
      still_running = system_command "/usr/bin/pgrep",
                                     args:         ["-f", executable],
                                     must_succeed: false
      break unless still_running.status.success?

      sleep 0.25
    end

    system_command "/usr/bin/open",
                   args:         ["-a", "/Applications/MacClipboard.app"],
                   must_succeed: false
  end

  # Quit before the bundle is replaced. `quit` is the documented way and is tried first;
  # `signal` is the fallback for when the Apple event is dropped. Modern Homebrew checks
  # whether the app is running before either, so neither warns on a fresh install.
  uninstall quit:   "com.macclipboard.app",
            signal: ["TERM", "com.macclipboard.app"]

  zap trash: [
    "~/Library/Application Support/MacClipboard",
    "~/Library/Caches/com.macclipboard.app",
    "~/Library/Preferences/com.macclipboard.app.plist",
  ]
end
