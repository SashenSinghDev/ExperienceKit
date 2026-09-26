# Design System

This document is the architecture reference for ExperienceKit design-system tokens and their mapping from Figma into SwiftUI.

## 1. Token Source Of Truth

**Principle:**
ExperienceKit styling should reference canonical design-system tokens, with Swift names and asset names matching the Figma token path one-to-one wherever possible.

**Guidelines:**

- Treat Figma token names as the source for semantic token shape.
- Put shared design tokens under `Sources/ExperienceKit/DesignSystem/`.
- Put colour assets under `Sources/ExperienceKit/DesignSystem/Assets.xcassets/Colors/`.
- Expose Swift accessors from `Sources/ExperienceKit/DesignSystem/Color+Extension.swift`.
- Use existing spacing and radius helpers when the Figma token already exists, for example `.spacing.small` for `spacing/small` and `.radius.full` for `radius/full`.

**AI Rule:**
Reject design-system additions that introduce a second naming scheme when a Figma semantic token path already exists.

---

## 2. Colour Tokens

**Principle:**
Colour token assets and Swift accessors should preserve the Figma token hierarchy.

**Guidelines:**

- Match the Figma token hierarchy in both the asset path and Swift enum shape.
- Add missing Figma colour tokens to `Assets.xcassets` instead of substituting `Color(.label)`, raw hex, or a component-local colour.
- Extend `Color+Extension.swift` with token-family enums such as `surface`, `text`, `labels`, and `separators`; keep enum and property names aligned to Figma token names using Swift casing where needed.
- Component-specific colour namespaces such as `Color.segmentedControl.selectedFill` should be avoided for shared design tokens.
- Components should consume the semantic token directly, for example `.fill(.surface.primary)`.
- Preserve existing component-scoped colours only when they represent a deliberately component-owned token already established in the asset catalog.

**Examples:**

| Figma token | Asset path | Swift accessor |
|---|---|---|
| `color/surface/primary` | `Colors/surface/primary.colorset` | `Color.surface.primary` |
| `color/text/primary` | `Colors/text/primary.colorset` | `Color.text.primary` |
| `color/labels/primary` | `Colors/labels/primary.colorset` | `Color.labels.primary` |
| `color/separators/non-opaque` | `Colors/separators/non-opaque.colorset` | `Color.separators.nonOpaque` |

**AI Rule:**
Reject new component styling that introduces raw colours, UIKit colour substitutions, or component-local colour aliases when a Figma semantic token exists or can be added to the design-system asset catalog.

---

## 3. Token Usage In Components

**Principle:**
Components should remain consumers of semantic tokens, not owners of duplicated styling decisions.

**Guidelines:**

- Reference semantic tokens directly in component views.
- Prefer token-family names that describe visual role, not component identity.
- Keep colour decisions out of view models unless the component has typed styling state that maps to existing tokens.
- Use `Color+Extension.swift`, spacing helpers, radius helpers, and typography helpers before introducing a new styling API.
- When implementing from Figma, copy the token role, not the rendered platform fallback. For example, if Figma says `color/surface/primary`, use `Color.surface.primary`, not `Color(.label)`.

**AI Rule:**
Reject component APIs that expose raw colour values or duplicate token names unless the product requirement explicitly needs caller-controlled styling.

---

## 4. Adding A New Colour Token

**Principle:**
Adding a token should update the asset catalog and Swift API together so runtime resources and source references cannot drift.

**Guidelines:**

- Add a `Contents.json` namespace folder when introducing a new colour token family, and set `provides-namespace` to `true`.
- Add the token `.colorset` under the matching Figma token path.
- Add the corresponding Swift accessor to `Color+Extension.swift`.
- Use camelCase only where Swift cannot represent the Figma token literally, for example `non-opaque` becomes `nonOpaque`.
- Build the package or host app after adding asset catalog tokens so asset compilation catches path or JSON mistakes.

**AI Rule:**
Reject colour-token changes where `Assets.xcassets` and `Color+Extension.swift` do not expose the same token.
