# App Experience Interactors

## Purpose

**Principle:**
The host app is the consumer of ExperienceKit. It composes experiences, owns app-specific flow state, and injects dependencies into the framework without moving product behavior into ExperienceKit.

## Core Types

**`Experience`**
Defines stable app-level experience ids. Add a case when a screen should be addressable through ExperienceKit navigation.

**`AppExperienceProvider`**
Acts as the app composition root. It translates an `ExperienceID` into an `ExperienceSession`, creates the interactor, and creates any app-owned per-session dependencies the interactor needs.

**`ExperienceSession`**
Carries the concrete interactor plus optional session dependencies that ExperienceKit should pass into component view models for that rendered session.

**`ExperienceInteractor`**
Builds the screen model in `load(completion:)` and handles app work in `performDeferredWork(workId:completion:)`.

**Services And Data Stores**
App-owned protocols, such as `PlanCalculationService`, that perform the work an interactor triggers. The provider creates them and injects them into interactors. See [APPEXPERIENCE_SERVICES.md](APPEXPERIENCE_SERVICES.md).

**Catalogue Interactors**
Catalogue or list interactors own discoverable entry points. Add public component demos to a catalogue only when a component should be browsable from the app.

## Interactor Responsibilities

**Principle:**
Each interactor owns one experience screen or one clear flow step.

**Guidelines:**

- Build the experience in `load(completion:)`.
- Prefer generated component builders such as `.buttonComponent(...)` and `.textComponent(...)`.
- Compose screens strictly from components available in ExperienceKit.
- Use ExperienceKit design-system tokens for typography, colour, spacing, radius, and other styling decisions.
- Do not introduce host-app-only visual styling, raw design values, or new design-system tokens from an app experience.
- If an app experience cannot be built with the current ExperienceKit component and token surface, extend ExperienceKit first through the component/design-system workflow.
- Keep layout helpers private to the interactor when they only serve that screen.
- Keep screen-specific constants, deferred work ids, and selection keys inside the interactor.
- Accept app dependencies through the interactor initializer.
- Move calculations, async work, networking, and persistence into injected services and data stores, and call them from the interactor. See [APPEXPERIENCE_SERVICES.md](APPEXPERIENCE_SERVICES.md).
- Keep SwiftUI layout and component implementation details out of app interactors.
- Return an `ExperienceType` from `load`; do not mutate component view models directly from the interactor.
- Use `experienceViewModel` only when the existing navigation or container APIs need it.

**AI Rule:**
Reject app interactors that reach into component views, own framework internals, use global mutable state for screen-local behavior, or create screens from UI/styling outside the existing ExperienceKit component and design-system surface.

**AI Rule:**
Reject app interactors that perform async work, delays, networking, persistence, or business calculations inline instead of calling an injected service or data store.

## Provider Wiring

**Principle:**
`AppExperienceProvider` should be the single place where app experiences are created.

**Guidelines:**

- Add a switch case for every `Experience` case.
- Return `ExperienceSession(interactor:)` when the screen has no extra session dependencies.
- Create app-owned dependencies in the provider when the screen needs shared state across component view models and the interactor.
- Pass the same dependency instance to the interactor and to `ExperienceSession`.
- For state shared across a multi-screen flow, hold the dependency on the provider instead of creating it per session; see [APPEXPERIENCE_SELECTIONSTATE.md](APPEXPERIENCE_SELECTIONSTATE.md#flow-scoped-stores).
- Keep concrete app dependency implementations in the app target, not in `Sources/ExperienceKit/`.
- Hold services and data stores on the provider, typed as their protocol, and inject them through the interactor initializer. They are not passed to `ExperienceSession`; see [APPEXPERIENCE_SERVICES.md](APPEXPERIENCE_SERVICES.md#provider-wiring).

Example:

```swift
case .selectionScreen:
    let selectionStateStore = AppExperienceSelectionStateStore()
    return .init(
        interactor: SelectionScreenInteractor(
            experienceViewModel: experienceViewModel,
            experienceSelectionStateStore: selectionStateStore
        ),
        selectionStateStore: selectionStateStore
    )
```

**AI Rule:**
Reject provider code that creates an interactor needing session state but does not pass the same state object through `ExperienceSession`.

## Creating A New App Screen

**Guidelines:**

1. Add an `Experience` case with a stable raw value.
2. Create an interactor in the app's AppExperience interactor area.
3. Implement `load(completion:)` using existing ExperienceKit components and design-system-backed component properties.
4. Add an `AppExperienceProvider` switch case returning an `ExperienceSession`.
5. Add navigation from the source screen to the new `Experience` case.
6. Add a catalogue entry only when the screen should be a discoverable catalogue item.
7. Add any new Swift file to the app target.
8. Build the app after changing app wiring.

**AI Rule:**
Flag new app screens that are reachable through navigation but missing provider wiring, or provider cases that point at interactors not included in the app target.

## Navigating Without A User Action

**Principle:**
A screen that moves on by itself, such as a loading or calculating step, navigates from its interactor. No component is involved.

The presenter keeps the `load(completion:)` closure, so an interactor may call it more than once: first with the screen to render, then with `.navigateImmediately(navigationViewModel:)` when its async work finishes.

The async work itself belongs to an injected service. The interactor only starts it and navigates when it completes.

```swift
func load(completion: @escaping (ExperienceType) -> Void) {
    completion(.fullScreen(properties: calculatingScreen()))

    planCalculationService.calculatePlan {
        completion(.navigateImmediately(navigationViewModel: .init(
            navigationType: .push(Experience.playgroundPlanReveal),
            deferredLoadingWorkId: nil,
            experienceViewModel: .init(searchBar: nil, navigationBar: nil))))
    }
}
```

**Guidelines:**

- Render the screen first, then start the async work.
- Run the async work in an injected service, not in a private method on the interactor.
- Call the completion on the main thread. Services complete on the main thread so the interactor can forward the result directly.
- Leave `deferredLoadingWorkId` as `nil` on the automatic navigation. A work id makes the presenter show its loading overlay on top of the screen while the work runs.
- Do not add navigation or work ids to visual components such as `animation` to drive this. The animation only draws; the interactor owns the work and the navigation.
- The pushed screen keeps the automatic screen beneath it in the stack, so navigating back returns to it without re-running `load`.

Reference: `PlaygroundCalculatingInteractor`, which waits on the injected `PlanCalculationService`.

**AI Rule:**
Reject automatic navigation that is triggered from a component view or view model instead of the interactor.

## Related Guidance

- Use [APPEXPERIENCE_DEFERREDWORK.md](APPEXPERIENCE_DEFERREDWORK.md) when a button or navigation action needs interactor-owned work.
- Use [APPEXPERIENCE_SELECTIONSTATE.md](APPEXPERIENCE_SELECTIONSTATE.md) when component selection state must be read by an interactor.
- Use [APPEXPERIENCE_ANIMATION.md](APPEXPERIENCE_ANIMATION.md) when a screen shows an animation supplied by the app.
- Use [APPEXPERIENCE_SERVICES.md](APPEXPERIENCE_SERVICES.md) when an interactor needs a service or data store to perform work.
- Use [COMPONENTCREATION.md](COMPONENTCREATION.md) when adding new ExperienceKit components or catalogue demos.
