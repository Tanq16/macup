<div align="center">
  <h1>macup</h1>

  <a href="#features">Features</a> &bull; <a href="#install">Install</a> &bull; <a href="#usage">Usage</a> &bull; <a href="#notes">Notes</a>
</div>

---

macup is a macOS menu bar app that keeps a Mac awake indefinitely. It is a toggle in front of `caffeinate`, the sleep-assertion tool that ships with macOS.

It exists because holding the machine awake with no timeout is the only thing most people ever use Amphetamine for. It is not a scheduler, a trigger engine, or a menu bar manager.

## Features

| Feature | Behavior |
|---|---|
| Toggle | One menu item starts and stops the sleep block |
| Icon state | Filled cup while active, outline while idle |
| Menu bar only | No Dock icon, no app switcher entry, no window |
| Quit | Releases the sleep block on the way out |

## Install

Download `macup.zip` from the [latest release](../../releases/latest), unzip it, and drag `macup.app` into `/Applications`.

Builds are arm64 only, for Apple Silicon Macs.

The app is ad-hoc signed rather than notarized, so Gatekeeper blocks it the first time. Right-click it, choose Open, and confirm once; macOS remembers the exception.

### From source

Needs Swift 6.1 or newer.

```bash
make app
```

Produces `macup.app` in the repository root.

## Usage

Click the cup in the menu bar:

- **Start** holds the sleep block until stopped. No timeout.
- **Stop** releases it.
- **Quit** releases it and exits.

## Notes

- **What it runs.** `caffeinate -d -i -m` as a child process, asserting against display sleep, idle sleep, and disk idle sleep. Passing no `-t` timeout is what makes it indefinite.
- **The block dies with the app.** Those assertions last exactly as long as the child process, so a crash or a force quit releases them rather than stranding an awake Mac.
- **Battery is not special-cased.** `caffeinate -s` prevents system sleep on AC power only, and macup does not pass it, so behavior is identical plugged in or not.
- **Releases come from commits.** A push to `main` cuts a patch release. `[minor-release]` or `[major-release]` in the commit message bumps the other components instead.
