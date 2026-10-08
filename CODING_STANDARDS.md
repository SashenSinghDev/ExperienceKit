# Coding Standards

Read this when reviewing a diff. Implementation guidance lives in [docs/architecture/](docs/architecture/README.md).

## 1. Checks First

`./scripts/check.sh` and CI (`.github/workflows/ci.yml`) decide the mechanical rules: component scaffold, registry agreement, content types, Example target membership, raw colours, generator output, compilation, and tests.

Confirm they ran and are green on the diff under review. A red or missing check is the first finding. Spend the rest of the review on the judgement calls below.

## 2. Rules By Path

Each architecture reference marks its review rules as **AI Rule**. *Reject* blocks the change. *Flag* is reported for the author to decide.

Apply every AI Rule in each reference whose row matches a path the diff touches:

| Diff touches | Reference |
| --- | --- |
| `Sources/ExperienceKit/Components/` | [COMPONENTCREATION.md](docs/architecture/COMPONENTCREATION.md), [DESIGNSYSTEM.md](docs/architecture/DESIGNSYSTEM.md) |
| `Sources/ExperienceKit/DesignSystem/` | [DESIGNSYSTEM.md](docs/architecture/DESIGNSYSTEM.md) |
| `Sources/ExperienceKit/Capabilities/`, `Sources/ExperienceKit/UI/` | [APPEXPERIENCE.md](docs/architecture/APPEXPERIENCE.md), [APPEXPERIENCE_DEFERREDWORK.md](docs/architecture/APPEXPERIENCE_DEFERREDWORK.md), [APPEXPERIENCE_SELECTIONSTATE.md](docs/architecture/APPEXPERIENCE_SELECTIONSTATE.md) |
| `Example/Example/AppExperience/Interactors/`, `AppExperienceProvider.swift`, `Models/Experience.swift` | [APPEXPERIENCE.md](docs/architecture/APPEXPERIENCE.md), [APPEXPERIENCE_DEFERREDWORK.md](docs/architecture/APPEXPERIENCE_DEFERREDWORK.md), [APPEXPERIENCE_SELECTIONSTATE.md](docs/architecture/APPEXPERIENCE_SELECTIONSTATE.md), [APPEXPERIENCE_SERVICES.md](docs/architecture/APPEXPERIENCE_SERVICES.md) |
| `Example/Example/AppExperience/Dependencies/` | [APPEXPERIENCE_SERVICES.md](docs/architecture/APPEXPERIENCE_SERVICES.md) |
| The `animation` component, `ExperienceAnimationProvider`, or `AppExperienceAnimationProvider.swift` | [APPEXPERIENCE_ANIMATION.md](docs/architecture/APPEXPERIENCE_ANIMATION.md) |

The review is complete when every AI Rule in every matched reference has a verdict against the diff.

## 3. Adding A Rule

A rule a script can decide (a fixed pattern, a banned API, a file location, two files that must agree) becomes a check in `scripts/check.sh`. Write an **AI Rule** in the matching reference only for a judgement call.
