# Component Creation

## 1. Generated Scaffold

**Principle:**
A new component should begin from the repo generator so registration, properties, view model, and view files follow the same shape as the existing component set.

**Guidelines:**

- Run `./generate_component.sh` from the repo root to create a new component.
- Enter the component name in PascalCase when prompted, matching the folder and type prefix you want under `Sources/ExperienceKit/Components/`.
- Let the script create the component folder and files:
  - `<Name>ComponentRegister.swift`
  - `<Name>Properties.swift`
  - `<Name>View.swift`
  - `<Name>ViewModel.swift`
- Let the script refresh `Sources/ExperienceKit/Components/Core/AllRegisters.swift`.
- Let the script refresh `Sources/ExperienceKit/Components/Core/ComponentExtensionBuilder.swift`.
- Inspect the generated diff before editing component behavior.
- Keep generated naming aligned with existing components such as `Button`, `Image`, `SelectionCard`, and `Welcome`.

**AI Rule:**
Reject new components that hand-create the initial scaffold instead of using `./generate_component.sh`, unless the generator is broken and the reason is documented.

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

## 3. Core Registration

**Principle:**
The core component registry should be updated by generation so every component can be created and rendered through the same ExperienceKit lookup path.

**Guidelines:**

- After running `./generate_component.sh`, confirm `AllRegisters.swift` includes `<Name>ComponentRegister()`.
- Confirm `ComponentExtensionBuilder.swift` includes a static builder for the new component.
- Use the generated static builder in example interactors instead of manually constructing `Component(contentType:properties:id:)`.
- Do not leave a generated component folder without a matching registry entry.
- Do not leave a registry entry pointing at a component that cannot compile.

**AI Rule:**
Reject component changes where the component files, `AllRegisters.swift`, and `ComponentExtensionBuilder.swift` disagree.

---

## 4. Example App Wiring

**Principle:**
A component added to the kit should be easy to discover and inspect in the example app.

**Guidelines:**

- Add an `Experience` case in `Example/Example/AppExperience/Models/Experience.swift` for the component's demo screen.
- Add an interactor in `Example/Example/AppExperience/Interactors/` that returns an `ExperienceType` containing the new component.
- Add a switch case in `Example/Example/AppExperience/AppExperienceProvider.swift` that returns the new interactor.
- Add a component entry in `Example/Example/AppExperience/Interactors/ExperienceListInteractor.swift` under the Components section.
- Include a separator before the new list item when it follows the existing component-list pattern.
- Give the list item a clear title and push navigation to the new `Experience` case.
- Set a navigation bar title that matches the visible component name.

**AI Rule:**
Reject public component additions that are not reachable from `ExperienceListInteractor` in the example app, unless the component is intentionally internal and that choice is documented in the change.

---

## 5. Verification

**Principle:**
Component changes should prove both the package and the example wiring still compile.

**Guidelines:**

- Run the narrowest meaningful package check after component source changes.
- Build or test the example app when changing `Example/Example/AppExperience/`.
- Confirm generated files do not contain stale placeholders from the templates.
- Confirm the new component appears in the example component list when launched.
- Document any skipped verification with the reason.

**AI Rule:**
Flag component changes that skip verification without explanation.
