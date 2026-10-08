# Component Creation

## 1. Generated Scaffold

**Principle:**
A new component should begin from the repo generator so registration, properties, view model, and view files follow the same shape as the existing component set.

**Guidelines:**

- Run `./generate_component.sh <Name>` to create a new component. `<Name>` is PascalCase and becomes the folder and type prefix under `Sources/ExperienceKit/Components/`.
- Let the script create the component folder and files:
  - `<Name>ComponentRegister.swift`
  - `<Name>Properties.swift`
  - `<Name>View.swift`
  - `<Name>ViewModel.swift`
- Let the script refresh `Sources/ExperienceKit/Components/Core/AllRegisters.swift`.
- Let the script refresh `Sources/ExperienceKit/Components/Core/ComponentExtensionBuilder.swift`.
- Inspect the generated diff before editing component behavior.
- Keep generated naming aligned with existing components such as `Button`, `Image`, `SelectionCard`, and `Welcome`.
- Run `./generate_component.sh --core` to refresh only the two core files, for example after renaming or deleting a component.

**Without Sourcery:**

The generator needs Sourcery, which runs on macOS. On a machine without it:

1. Render the four files from `Templates/Component/*.stencil`, replacing `{{ argument.component }}` with the name and `{{ argument.component | lowercase }}` with its lowercase form.
2. Add the register to `AllRegisters.swift` and the builder to `ComponentExtensionBuilder.swift`, each in alphabetical order by type name, in the shape `Templates/Core/*.stencil` produces.
3. Run `./scripts/check.sh` until it passes.
4. Say in the pull request that the scaffold was rendered by hand. CI's `Component generator` job then proves the two core files are byte-identical to the generator's output.

**AI Rule:**
Reject new components that hand-create the initial scaffold when Sourcery is available.

---

## 2. Component Contract

**Principle:**
Each component should expose a small typed contract: properties describe input data, the view model prepares renderable state, the view renders SwiftUI, and the register connects the component to ExperienceKit.

**Guidelines:**

- Put component source in `Sources/ExperienceKit/Components/<Name>/`.
- Keep public input on `<Name>Properties`.
- Keep render-ready transformation in `<Name>ViewModel`.
- Keep `<Name>View` focused on layout and visual rendering.
- Keep `<Name>ComponentRegister` mechanical:
  - `contentType` is the stable lowercase component type.
  - `propertiesType` points to `<Name>Properties.self`.
  - `viewModel(from:dependency:)` creates `<Name>ViewModel`.
  - `view(from:)` returns `<Name>View`.
- Prefer existing design-system helpers under `Sources/ExperienceKit/DesignSystem/` for spacing, radius, colors, and typography.
- Keep behavior testable by moving decisions out of SwiftUI layout code when the component grows beyond simple rendering.

**AI Rule:**
Reject component views that own business decisions, parsing, or registration behavior that belongs in properties, view models, or registers.

---

## 3. Design System Usage

**Principle:**
Components should consume canonical ExperienceKit design-system tokens instead of owning ad hoc styling.

**Guidelines:**

- Read [DESIGNSYSTEM.md](DESIGNSYSTEM.md) before adding or consuming design-system colour, spacing, radius, or typography tokens.
- Prefer existing design-system helpers under `Sources/ExperienceKit/DesignSystem/` for spacing, radius, colors, and typography.
- When a Figma token is missing from the design system, add it following [DESIGNSYSTEM.md](DESIGNSYSTEM.md) instead of substituting raw colours or component-local aliases.
- New design-system values are only added when extending ExperienceKit itself, such as creating or changing a component.
- Figma is the source of truth for new design-system values, and token additions should map one-to-one to the Figma token path.
- Keep component views as consumers of semantic tokens, for example `.fill(.surface.primary)`.

**AI Rule:**
Reject component styling that bypasses the design-system token guidance in [DESIGNSYSTEM.md](DESIGNSYSTEM.md).

---

## 4. Core Registration

**Principle:**
The core component registry should be updated by generation so every component can be created and rendered through the same ExperienceKit lookup path.

**Guidelines:**

- After running `./generate_component.sh`, confirm `AllRegisters.swift` includes `<Name>ComponentRegister()`.
- Confirm `ComponentExtensionBuilder.swift` includes a static builder for the new component.
- Use the generated static builder in example interactors instead of manually constructing `Component(contentType:properties:id:)`.
- Do not leave a generated component folder without a matching registry entry.
- Do not leave a registry entry pointing at a component that cannot compile.

**Enforced by checks:**
`./scripts/check.sh` fails when the component files, `AllRegisters.swift`, and `ComponentExtensionBuilder.swift` disagree, or when a register's `contentType` differs from the type its builder creates. CI's `Component generator` job fails when the two core files differ from the generator's output.

---

## 5. App Catalogue Wiring

**Principle:**
A component added to the kit should be easy to discover and inspect in an app catalogue.

**Guidelines:**

- Add an `Experience` case in `Example/Example/AppExperience/Models/Experience.swift` for the component's demo screen.
- Add an app interactor that returns an `ExperienceType` containing the new component.
- Add a switch case in `Example/Example/AppExperience/AppExperienceProvider.swift` that returns the new interactor.
- Add a component entry in `Example/Example/AppExperience/Interactors/ExperienceListInteractor.swift` under the Components section.
- Include a separator before the new list item when it follows the existing component-list pattern.
- Give the list item a clear title and push navigation to the new `Experience` case.
- Set a navigation bar title that matches the visible component name.
- Read [APPEXPERIENCE.md](APPEXPERIENCE.md) before adding custom flow behavior, deferred work, or app-owned state to an app interactor.
- Compose catalogue screens with ExperienceKit components and design-system tokens only.

**AI Rule:**
Reject public component additions that are not reachable from the app catalogue, unless the component is intentionally internal and that choice is documented in the change.

---

## 6. Verification

**Principle:**
Component changes should prove both the package and the example wiring still compile.

**Guidelines:**

- Run `./scripts/check.sh` after every component or app wiring change. It needs no Swift toolchain.
- Run `./scripts/build_and_test.sh` on macOS with Xcode: `package` runs the package tests, `example` builds the host app. Without Xcode, CI runs both on the pull request.
- Confirm generated files do not contain stale placeholders from the templates.
- Confirm the new component appears in the example component list when launched.
- Document any skipped verification with the reason.

**AI Rule:**
Flag component changes that skip verification without explanation.
