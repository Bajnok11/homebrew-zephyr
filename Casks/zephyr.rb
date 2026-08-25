cask "zephyr" do
  version "1.0"
  sha256 "2d566f2b1581eec183e3f79545a2236631574009e71e84012a64ae2006525529"

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

  # Fan control needs a root helper, which the app installs on first use into
  # /Library. Dragging the app to the trash would leave that LaunchDaemon
  # running forever, so uninstall tears it down properly. These paths are
  # root-owned, so Homebrew will ask for your password.
  uninstall launchctl: "com.bence.zephyr.helper",
            delete:    [
              "/Library/Application Support/Zephyr",
              "/Library/LaunchDaemons/com.bence.zephyr.helper.plist",
              "/var/log/zephyr-helper.log",
            ]

  zap trash: "~/Library/Application Support/Zephyr"
end
