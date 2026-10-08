# ExperienceKit Agent Guide

Canonical guidance lives in this file and `docs/architecture/`. Provider-specific files such as `CLAUDE.md` only import this one.

## Architecture References

Before implementing, planning, or refactoring, read [docs/architecture/README.md](docs/architecture/README.md) and every reference it routes your task surface to.

Reviewing a diff: read [CODING_STANDARDS.md](CODING_STANDARDS.md).

## Quick Reference

**Components**: See [docs/architecture/COMPONENTCREATION.md](docs/architecture/COMPONENTCREATION.md) before adding, wiring, or reviewing a component.

**Generated component scaffolds**: Create new components with `./generate_component.sh <Name>`. It needs Sourcery; COMPONENTCREATION.md section 1 covers the route without it.

**Example catalogue**: When adding a component, expose it through the example app and add a list entry in `Example/Example/AppExperience/Interactors/ExperienceListInteractor.swift`.

**Services and data stores**: Interactors call injected services and data stores for calculations, async work, networking, and persistence. They live under `Example/Example/AppExperience/Dependencies/`. See [docs/architecture/APPEXPERIENCE_SERVICES.md](docs/architecture/APPEXPERIENCE_SERVICES.md) before adding one or putting such work in an interactor.

## Verification

- `./scripts/check.sh` runs anywhere, with no Swift toolchain. Run it before every commit.
- `./scripts/build_and_test.sh` runs the package tests on an iOS simulator and builds the Example app. It needs macOS with Xcode; the package is iOS-only, so `xcodebuild` on a simulator is the route, and the script holds the commands.
- CI (`.github/workflows/ci.yml`) runs both, plus the component generator, on every pull request. Without Xcode, push the branch and read the pull request's checks: the change is verified when they are green.

State in the pull request which of these ran and what they reported.
