# homebrew-zephyr

Homebrew tap for [Zephyr](https://github.com/Bajnok11/Zephyr) — a native macOS menu bar app for fan control, with presets and drag-to-edit fan curves.

## Install

```bash
brew tap Bajnok11/zephyr
```

Recent Homebrew versions refuse to run casks from a third-party tap until you say you trust it, so this step is needed once:

```bash
brew trust --cask Bajnok11/zephyr/zephyr
```

```bash
brew install --cask zephyr
```

Then open Zephyr and press **Install** in **Settings → General** to set up the privileged helper. macOS asks for your admin password in its own dialog — the app never handles it.

## Apple Silicon only

The released build is arm64. Intel Macs use the same SMC keys and should work, but that has not been verified and there is no Intel binary — [build from source](https://github.com/Bajnok11/Zephyr#build-from-source) there.

## Heads up: not notarized

Zephyr is signed ad-hoc rather than with a paid Apple Developer ID certificate, so it is not notarized. Gatekeeper blocks unnotarized downloads outright, so this cask's `postflight` step clears the quarantine flag after install — otherwise `brew install --cask zephyr` would leave you with an app that refuses to open.

If that trade-off doesn't sit right with you, the [main repo](https://github.com/Bajnok11/Zephyr) has build-from-source instructions that take about a minute.

## Uninstalling

```bash
brew uninstall --cask zephyr
```

Fan control runs through a root LaunchDaemon that the app installs outside its own bundle, so the cask tears that down too. Homebrew will ask for your password for those paths. `--zap` additionally removes your presets and settings.

## Updating the cask for a new release

1. Tag a new Zephyr release and attach `Zephyr-X.Y.Z-arm64.zip`.
2. Update `version` and `sha256` in `Casks/zephyr.rb` (`shasum -a 256 Zephyr-X.Y.Z-arm64.zip`).
3. Commit and push.

## Licence

MIT, same as Zephyr itself.
