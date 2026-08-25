cask "zephyr" do
  version "1.0.1"
  sha256 "2c6cb4f286911b7bb29687ea54bb4df60b2c2572a2d1352a801b69dae61be9d2"

  url "https://github.com/Bajnok11/Zephyr/releases/download/v#{version}/Zephyr-#{version}-arm64.zip"
  name "Zephyr"
  desc "Menu bar fan control with presets and drag-to-edit fan curves"
  homepage "https://github.com/Bajnok11/Zephyr"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Zephyr.app"

  # Zephyr is signed ad-hoc, not with a paid Developer ID certificate, so it is
  # not notarized. Gatekeeper blocks that on a fresh download, which would make
  # `brew install --cask zephyr` produce an app that refuses to open. Clearing
  # the quarantine flag here keeps the install working; the trade is the same
  # one every unnotarized community cask makes, and it goes away if the project
  # ever moves to a $99/year Developer ID certificate.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Zephyr.app"],
                   sudo: false
  end

  uninstall quit: "com.bence.zephyr"

  # The root helper deliberately lives in zap, not uninstall. Homebrew runs the
  # uninstall stanza on every *upgrade* as well, so tearing the LaunchDaemon
  # down there would switch fan control off each time the app updates and leave
  # the user needing a privileged reinstall they were never told about.
  # `brew zap --cask zephyr` removes it, as does the Remove button in the app's
  # Settings → General. Those paths are root-owned, so Homebrew asks for a
  # password.
  zap launchctl: "com.bence.zephyr.helper",
      trash:     "~/Library/Application Support/Zephyr",
      delete:    [
        "/Library/Application Support/Zephyr",
        "/Library/LaunchDaemons/com.bence.zephyr.helper.plist",
        "/var/log/zephyr-helper.log",
      ]
end
