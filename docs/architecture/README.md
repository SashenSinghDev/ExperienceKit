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
- [APPEXPERIENCE_DEFERREDWORK.md](APPEXPERIENCE_DEFERREDWORK.md) - Deferred work id ownership, button/navigation handoff, value change handoff, work that carries values, and `performDeferredWork` guidance
- [APPEXPERIENCE_SELECTIONSTATE.md](APPEXPERIENCE_SELECTIONSTATE.md) - How components report selections through `onChangeWorkId`, and how interactors seed, write, and read the app-owned selection state store
- [APPEXPERIENCE_ANIMATION.md](APPEXPERIENCE_ANIMATION.md) - App-owned animation provider, the `animation` component contract, and `ExperienceSession` wiring
- [APPEXPERIENCE_SERVICES.md](APPEXPERIENCE_SERVICES.md) - App-owned services and data stores, the `Dependencies/` folder structure, interactor injection, and provider ownership

Start here when:

- Adding, changing, or reviewing an app interactor
- Creating a new app flow screen
- Wiring an `Experience` case through `AppExperienceProvider`
- Adding button work that runs through `performDeferredWork`
- Capturing the values a user selects or types, or sharing them between screens
- Adding `onChangeWorkId` to a component
- Showing an animation, or adding an animation library to the app
- Adding a service or data store, or moving calculations, async work, networking, or persistence out of an interactor

### Design System

- [DESIGNSYSTEM.md](DESIGNSYSTEM.md) - Figma-to-Swift token mapping, colour asset naming, Swift token accessors, and component token usage

Start here when:

- Adding or consuming design-system colour, spacing, radius, or typography tokens
- Mapping Figma tokens to `Assets.xcassets` and Swift accessors
- Reviewing raw colours, UIKit colour substitutions, or component-local colour aliases
- Updating `Sources/ExperienceKit/DesignSystem/`

## Review Rules

Each document marks its review rules as **AI Rule**. Reviewing a diff starts at [CODING_STANDARDS.md](../../CODING_STANDARDS.md), which routes changed paths to these documents.

## Contributing To These Docs

Keep docs focused and actionable:

- Lead with the principle, then guidelines.
- Include concrete paths and reference implementations.
- Turn a rule a script can decide into a check in `scripts/check.sh`. Write an **AI Rule** only for a judgement call.
- Prefer examples from this codebase over abstract descriptions.
- Update docs when architecture decisions change.
