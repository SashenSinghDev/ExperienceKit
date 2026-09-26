# ExperienceKit Architecture Documentation

This directory contains the authoritative architectural guidance for ExperienceKit development.

## Quick Navigation

Read the narrowest document that matches your task:

### Component Creation

- [COMPONENTCREATION.md](COMPONENTCREATION.md) - Component generation, implementation, registration, app wiring, and catalogue exposure

Start here when:

- Creating a new component
- Changing a component's properties, view model, view, or register
- Reviewing generated component registry changes
- Adding a component to an app catalogue
- Updating `ExperienceListInteractor` for a new component

### App Experience Interactors

- [APPEXPERIENCE.md](APPEXPERIENCE.md) - App experience architecture, interactor responsibilities, `AppExperienceProvider`, and `ExperienceSession` wiring
- [APPEXPERIENCE_DEFERREDWORK.md](APPEXPERIENCE_DEFERREDWORK.md) - Deferred work id ownership, button/navigation handoff, and `performDeferredWork` guidance
- [APPEXPERIENCE_SELECTIONSTATE.md](APPEXPERIENCE_SELECTIONSTATE.md) - App-owned selection state stores, component write paths, and interactor read paths

Start here when:

- Adding, changing, or reviewing an app interactor
- Creating a new app flow screen
- Wiring an `Experience` case through `AppExperienceProvider`
- Adding button work that runs through `performDeferredWork`
- Sharing selected component values with an interactor

### Design System

- [DESIGNSYSTEM.md](DESIGNSYSTEM.md) - Figma-to-Swift token mapping, colour asset naming, Swift token accessors, and component token usage

Start here when:

- Adding or consuming design-system colour, spacing, radius, or typography tokens
- Mapping Figma tokens to `Assets.xcassets` and Swift accessors
- Reviewing raw colours, UIKit colour substitutions, or component-local colour aliases
- Updating `Sources/ExperienceKit/DesignSystem/`

## AI Rules Overview

Each architecture document includes AI rules for agents:

- **Reject** patterns that violate the principles
- **Flag** existing code that diverges from the rules
- **Steer** refactors toward the target architecture
- **Prefer** generated scaffolds and explicit wiring over ad hoc component setup

## When To Consult These Docs

Before implementing:

1. Identify the ExperienceKit surface your change touches.
2. Read the corresponding document.
3. Scan for AI rules that apply to your change.
4. Verify your approach against the guidelines before coding.

During code review:

1. Check that the implementation follows the corresponding document's patterns.
2. Flag deviations and suggest alignment.
3. Prefer these docs over personal preference.

## Principles

- **Generated first**: Use repo tooling to create repeatable component scaffolds.
- **Explicit examples**: Components intended for humans to inspect should be reachable from an app catalogue.
- **Typed properties**: Components should expose clear property and view model types.
- **Small views**: SwiftUI views should render state and keep behavior out of layout code.
- **Catalogue visibility**: New components should appear in the example component list when they are part of the public component set.
- **Token fidelity**: Design-system tokens should preserve Figma naming and hierarchy in asset paths and Swift accessors.
- **App-owned experience state**: App flow state should be owned by the host app and injected into ExperienceKit through `ExperienceSession`.

## Contributing To These Docs

Keep docs focused and actionable:

- Lead with the principle, then guidelines.
- Include concrete paths and reference implementations.
- Add AI rules for agents to enforce compliance.
- Prefer examples from this codebase over abstract descriptions.
- Update docs when architecture decisions change.
