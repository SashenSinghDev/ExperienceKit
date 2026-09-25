# ExperienceKit Architecture Documentation

This directory contains the authoritative architectural guidance for ExperienceKit development.

## Quick Navigation

Read the narrowest document that matches your task:

### Component Creation

- [COMPONENTCREATION.md](COMPONENTCREATION.md) - Component generation, implementation, registration, example wiring, and catalogue exposure

Start here when:

- Creating a new component
- Changing a component's properties, view model, view, or register
- Reviewing generated component registry changes
- Adding a component to the example app
- Updating `ExperienceListInteractor` for a new component

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
- **Explicit examples**: Components intended for humans to inspect should be reachable from the example app.
- **Typed properties**: Components should expose clear property and view model types.
- **Small views**: SwiftUI views should render state and keep behavior out of layout code.
- **Catalogue visibility**: New components should appear in the example component list when they are part of the public component set.
- **Token fidelity**: Design-system tokens should preserve Figma naming and hierarchy in asset paths and Swift accessors.

## Contributing To These Docs

Keep docs focused and actionable:

- Lead with the principle, then guidelines.
- Include concrete paths and reference implementations.
- Add AI rules for agents to enforce compliance.
- Prefer examples from this codebase over abstract descriptions.
- Update docs when architecture decisions change.
