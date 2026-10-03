# App Experience Services And Data Stores

## Purpose

**Principle:**
An interactor decides what a screen shows and where the flow goes next. The work behind those decisions (calculations, network calls, persistence, analytics) lives in app-owned services and data stores that are injected into the interactor.

The interactor calls the dependency and turns its result into an `ExperienceType`. It does not contain the work itself.

## Core Flow

```mermaid
sequenceDiagram
    participant Provider as AppExperienceProvider
    participant Service as PlanCalculationService
    participant Interactor as App interactor
    participant Presenter as Experience presenter

    Provider->>Service: Create and hold the concrete service
    Provider->>Interactor: Inject service through the initializer
    Presenter->>Interactor: load(completion)
    Interactor-->>Presenter: completion(screen to render)
    Interactor->>Service: calculatePlan(completion)
    Service-->>Interactor: completion on the main thread
    Interactor-->>Presenter: completion(.navigateImmediately)
```

## What Belongs Where

| Type | Owns | Examples |
| --- | --- | --- |
| Interactor | Screen composition, flow decisions, mapping results to `ExperienceType` | `PlaygroundCalculatingInteractor` |
| Service | Work and business logic the interactor triggers | `PlanCalculationService`, an API client, analytics |
| Data store | State that is read and written over time | `SelectionStateStore`, a persisted profile store, a cache |

A service or data store never returns ExperienceKit types such as `Component` or `ExperienceType`, and never navigates. It returns app data; the interactor decides what to do with it.

## Folder Structure

App-owned dependencies that are injected into interactors live under `Example/Example/AppExperience/Dependencies/`, split by kind:

```text
Example/Example/AppExperience/
├── AppExperienceProvider.swift
├── AppExperienceAnimationProvider.swift
├── Dependencies/
│   ├── Services/
│   │   └── PlanCalculationService.swift
│   └── Strores/
│       └── AppExperienceSelectionStateStore.swift
├── Interactors/
├── Models/
└── Views/
```

| Folder | Holds | Example |
| --- | --- | --- |
| `Dependencies/Services/` | Services: work and business logic an interactor triggers | `PlanCalculationService.swift` |
| `Dependencies/Strores/` | Data stores: state that is read and written over time | `AppExperienceSelectionStateStore.swift` |

**Guidelines:**

- Put a new service in `Dependencies/Services/` and a new data store in `Dependencies/Strores/`.
- Keep a protocol and its app implementation in the same file, named for the protocol or the concrete type.
- Add a new kind of injected dependency as its own folder under `Dependencies/`, not beside the interactors.
- `AppExperienceProvider.swift` and `AppExperienceAnimationProvider.swift` stay at the `AppExperience/` root. They are wired into ExperienceKit, not injected into interactors.

**AI Rule:**
Flag services or data stores that are added outside `Example/Example/AppExperience/Dependencies/`, or placed in the wrong subfolder for their kind.

## Defining A Service Or Data Store

**Guidelines:**

- Declare a protocol named for what the dependency does, such as `PlanCalculationService`.
- Keep the protocol and its concrete implementations in the app target, under `Example/Example/AppExperience/Dependencies/` as described in [Folder Structure](#folder-structure). Do not add them to `Sources/ExperienceKit/`.
- Prefix the app's concrete implementation with `App`, such as `AppPlanCalculationService` and `AppExperienceSelectionStateStore`.
- Keep timing, endpoints, and other implementation constants inside the concrete type, not in the interactor.
- Call completions on the main thread, and state this on the protocol. The interactor forwards the result straight to the presenter.
- Call the completion exactly once on every path.
- Add the new Swift file to the app target.

Example:

```swift
protocol PlanCalculationService {
    /// Calculates the plan, then calls `completion` on the main thread.
    func calculatePlan(completion: @escaping () -> Void)
}

final class AppPlanCalculationService: PlanCalculationService {
    private let calculationDuration: TimeInterval

    init(calculationDuration: TimeInterval = Timing.calculationDuration) {
        self.calculationDuration = calculationDuration
    }

    func calculatePlan(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + calculationDuration, execute: completion)
    }
}
```

**AI Rule:**
Reject services or data stores that are declared inside `Sources/ExperienceKit/`, that return ExperienceKit component or experience types, or that trigger navigation.

## Injecting Into An Interactor

**Guidelines:**

- Accept each dependency through the interactor initializer and store it as a `private let`.
- Type the stored property as the protocol, never the concrete class.
- Do not create a service inside an interactor, and do not reach for a singleton or static accessor.
- Do not give injected dependencies default values in the interactor initializer. The provider is the only place a concrete type is chosen.
- Inject only what the screen uses.

Example:

```swift
final class PlaygroundCalculatingInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    private let selectionStateStore: SelectionStateStore
    private let planCalculationService: PlanCalculationService

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         selectionStateStore: SelectionStateStore,
         planCalculationService: PlanCalculationService) {
        self.experienceViewModel = experienceViewModel
        self.selectionStateStore = selectionStateStore
        self.planCalculationService = planCalculationService
    }
}
```

**AI Rule:**
Reject interactors that perform async work, delays, networking, persistence, or business calculations inline. Move the work into an injected service or data store.

**AI Rule:**
Reject interactors that instantiate their own services, read them from a singleton, or store them as a concrete type.

## Provider Wiring

`AppExperienceProvider` is the composition root. It creates the concrete dependency and passes it to every interactor that needs it.

```swift
private let playgroundFlowSelectionStateStore: SelectionStateStore = AppExperienceSelectionStateStore()
private let planCalculationService: PlanCalculationService = AppPlanCalculationService()

case .playgroundCalculating:
    return .init(
        interactor: PlaygroundCalculatingInteractor(
            experienceViewModel: experienceViewModel,
            selectionStateStore: playgroundFlowSelectionStateStore,
            planCalculationService: planCalculationService
        ),
        animationProvider: animationProvider
    )
```

**Guidelines:**

- Hold services and data stores as private properties on `AppExperienceProvider`, typed as their protocol.
- Do not create a stateful dependency inside `experienceSession(for:)`. ExperienceKit calls it again whenever SwiftUI re-evaluates the navigation stack, so state created there is lost or split.
- Share one instance between interactors that must see the same data.
- Services and data stores are injected into the interactor only. `ExperienceSession` carries the dependencies ExperienceKit hands to component view models, such as `animationProvider`; app services and data stores do not go through it.

**AI Rule:**
Flag concrete service types that are named anywhere outside `AppExperienceProvider` and the service's own file.

## Calling A Dependency

Call the dependency from `load(completion:)` or `performDeferredWork(workId:values:completion:)`, then map its result to the completion.

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

- Render the screen before starting work that should not block it. See [Navigating Without A User Action](APPEXPERIENCE.md#navigating-without-a-user-action).
- Call the interactor's completion exactly once per result the service delivers.
- Keep presentation concerns in the interactor: copy, component layout, and the choice of next `Experience`.

## Selection State Stores

`SelectionStateStore` is an app data store like any other: declared in the app target, held by the provider, and injected into interactors. Components never write to it. They report changes to the interactor through deferred work, and the interactor writes. See [APPEXPERIENCE_SELECTIONSTATE.md](APPEXPERIENCE_SELECTIONSTATE.md).

Reference: `PlanCalculationService`, `AppPlanCalculationService`, `SelectionStateStore`, and `PlaygroundCalculatingInteractor`.
