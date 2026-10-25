
# CloverVM

<p align="center">
  <strong>A modern virtual machine manager for iOS and iPadOS.</strong>
  <br>
  Built by <strong>Clover</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20iPadOS-6478ff?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/badge/Language-SwiftUI-orange?style=for-the-badge" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Status-Early%20Development-yellow?style=for-the-badge" alt="Development status">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
</p>

---

## About

**CloverVM** is an experimental virtual machine management app for iOS and iPadOS, developed by **Clover**.

The project aims to provide a modern, native interface for organizing virtual machines and configuring their settings, with the long-term goal of integrating a suitable virtualization backend.

CloverVM is currently focused on its SwiftUI interface and application architecture. Actual virtual machine execution is not implemented yet.

## Features

- **VM Dashboard** — view and organize virtual machine profiles.
- **Machine Configuration** — create profiles and configure basic settings.
- **ISO Selection** — select installation images using the system file picker.
- **Machine Details** — inspect individual virtual machine configurations.
- **Settings** — access application preferences.
- **Native Interface** — SwiftUI interface designed for iPhone and iPad.
- **Automated Builds** — build verification through GitHub Actions.

> Some features are currently interface prototypes and do not yet control a working virtualization engine.

## Project Status

CloverVM is in **early development**.

| Component | Status |
|---|---|
| SwiftUI application structure | In progress |
| VM dashboard | Prototype |
| VM configuration interface | Prototype |
| ISO file selection | Prototype |
| Persistent VM data | In progress |
| Virtualization backend | Not implemented |
| Guest OS boot and execution | Not implemented |
| Signed IPA distribution | Not configured |

## Compatibility

- **Platforms:** iOS and iPadOS
- **Deployment Target:** iOS 17.0+
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Build System:** Xcode and GitHub Actions

Actual virtualization capabilities will depend on device hardware, operating-system restrictions, available APIs, runtime requirements, and the backend eventually selected.

## Building

### Using Xcode

1. Clone or download this repository.
2. Open `CloverVM.xcodeproj` in Xcode on a compatible Mac.
3. Select the `CloverVM` scheme.
4. Choose an iOS Simulator destination.
5. Build and run the project.

### Using GitHub Actions

1. Push the project to GitHub.
2. Open the repository's **Actions** tab.
3. Select **CloverVM iOS Build**.
4. Run the workflow or push a commit.
5. Download the artifacts after a successful build.

The simulator build is intended for simulator testing. The unsigned IPA artifact requires compatible signing before it can be installed on a physical iPhone or iPad.

## Roadmap

- [x] Create the SwiftUI application structure
- [x] Configure the Xcode project and shared scheme
- [x] Set up GitHub Actions build automation
- [x] Add unsigned IPA packaging to CI
- [ ] Improve responsive iPhone and iPad layouts
- [ ] Improve VM profile persistence and validation
- [ ] Select and integrate a feasible virtualization backend
- [ ] Implement VM lifecycle controls
- [ ] Document hardware and OS compatibility
- [ ] Explore a signed distribution workflow

The roadmap may change as development progresses.

## Limitations

CloverVM is **not yet a functioning hypervisor**. The current version is a management-interface prototype; creating a VM profile does not mean that a guest operating system can boot.

Virtualization on iOS and iPadOS depends on platform APIs, device hardware, operating-system restrictions, and runtime requirements. Support for specific operating systems will be evaluated as the project develops.

## Contributing

Suggestions, bug reports, and contributions are welcome.

Before submitting a pull request:

1. Explain the issue or proposed improvement.
2. Keep changes focused and document platform-specific assumptions.
3. Verify that the project and GitHub Actions workflow still build.

## License

CloverVM is distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

---

<p align="center">
  Made with SwiftUI by <strong>Clover</strong>
</p>
