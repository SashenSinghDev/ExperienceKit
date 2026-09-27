# Apple Human Interface Guidelines

This document is the architecture reference for grounding ExperienceKit component design and styling decisions in Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) (HIG).

## 1. HIG First For Component Behaviour

**Principle:**
When a component has a matching HIG page, follow what Apple recommends for that kind of control before inventing custom styling. Prefer the system's own behaviour and styles, and add customisation only where the HIG allows it and a design need exists.

**Guidelines:**

- Before adding or changing a component's appearance, states or interaction, read the HIG page for that control (see [section 3](#3-component-to-hig-map)) and any cross-cutting page it depends on, such as Color, Materials or Typography.
- Prefer native SwiftUI styles and modifiers that already implement the HIG (for example `.buttonStyle(.glass)`, `.glassEffect(...)`, semantic colours, Dynamic Type) over hand-built look-alikes.
- Only add custom visual treatment (tints, strokes, shadows, overlays) when the HIG supports it for that role. If the platform material already draws something, such as the Liquid Glass edge highlight and shadow, do not draw it again.
- Reserve emphasis for what the HIG reserves it for, for example accent colour and prominent styles for the one or two most likely actions in a view.
- Record the HIG basis for non-obvious choices in the component's doc comment, the Figma component description and the PR description, linking the HIG section.

**AI Rule:**
Reject component styling that adds custom treatment the HIG advises against for that control, or that recreates something the system style already provides, unless the change states the reason and the HIG section it departs from.

---

## 2. HIG And Figma Together

**Principle:**
Figma is the source of truth for token *values* (see [DESIGNSYSTEM.md](DESIGNSYSTEM.md)). The HIG is the source of truth for *how a kind of control should behave and be styled*. They should agree; when they don't, surface the conflict instead of silently picking one.

**Guidelines:**

- Check a Figma component against the HIG before implementing it. A Figma design is not automatically HIG-compliant.
- If Figma asks for something the HIG advises against (for example a neutral tint on every glass button), flag it to the user with the HIG reference and a recommended fix, and change Figma and code together once agreed.
- Keep token changes one-to-one between Figma and code, following [DESIGNSYSTEM.md](DESIGNSYSTEM.md). HIG guidance changes *which* token role is used, not the token-mapping rules.
- Prefer existing Apple semantic roles already in the Figma variables (for example `color/labels-vibrant/*` for labels on materials) over new component-scoped tokens.

**AI Rule:**
Flag Figma-to-code changes that follow Figma where it contradicts the HIG without calling out the conflict.

---

## 3. Component To HIG Map

Read the listed pages before changing a component. Cross-cutting pages apply to every component.

| Component | HIG pages |
|---|---|
| `Button` | [Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons), [Color › Liquid Glass color](https://developer.apple.com/design/human-interface-guidelines/color#Liquid-Glass-color), [Materials](https://developer.apple.com/design/human-interface-guidelines/materials) |
| `TextField` | [Text fields](https://developer.apple.com/design/human-interface-guidelines/text-fields) |
| Bottom search bar (`ExperienceView`) | [Search fields](https://developer.apple.com/design/human-interface-guidelines/search-fields), [Materials](https://developer.apple.com/design/human-interface-guidelines/materials) |
| `SegmentedControl` | [Segmented controls](https://developer.apple.com/design/human-interface-guidelines/segmented-controls) |
| `ProgressStepper` | [Progress indicators](https://developer.apple.com/design/human-interface-guidelines/progress-indicators) |
| `GenericListItem`, `SelectionCard` | [Lists and tables](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables) |
| `Image` | [Images](https://developer.apple.com/design/human-interface-guidelines/images) |
| `Text`, `SectionTitle`, `Description` | [Typography](https://developer.apple.com/design/human-interface-guidelines/typography) |
| `Container`, `HorizontalContainer`, `Spacer`, `Separator` | [Layout](https://developer.apple.com/design/human-interface-guidelines/layout) |
| `Welcome` | [Onboarding](https://developer.apple.com/design/human-interface-guidelines/onboarding), plus the `Button`, `Image` and `Text` rows for its parts |
| **All components** | [Color](https://developer.apple.com/design/human-interface-guidelines/color), [Dark Mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode), [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility), [Typography](https://developer.apple.com/design/human-interface-guidelines/typography) |
| Anything using Liquid Glass | [Materials › Liquid Glass](https://developer.apple.com/design/human-interface-guidelines/materials), [Color › Liquid Glass color](https://developer.apple.com/design/human-interface-guidelines/color#Liquid-Glass-color) |

When adding a new component, add its row here in the same change. If no HIG page matches, use the closest control and the cross-cutting pages, and say so in the PR.

**AI Rule:**
Reject new components that do not add a row to this map.

---

## 4. Reading The HIG As An Agent

**Principle:**
Agents should read the current HIG text rather than rely on memory, because Apple updates the guidance (Liquid Glass changed a lot in iOS 26).

**Guidelines:**

- HIG web pages render with JavaScript, so fetching `https://developer.apple.com/design/human-interface-guidelines/<page>` returns an empty shell.
- Fetch the page's JSON instead: `https://developer.apple.com/tutorials/data/design/human-interface-guidelines/<page>.json`, for example `.../buttons.json` or `.../color.json`. Use the web-fetch tool, not `curl` from the workspace shell, which is usually blocked.
- Cite the specific section (for example `color#Liquid-Glass-color`) in recommendations, and paraphrase it rather than quoting at length.
- If the HIG can't be reached, say so and mark the recommendation as unverified rather than presenting remembered guidance as current.

**AI Rule:**
Flag HIG-based recommendations that don't cite the HIG page they rely on.

---

## 5. Liquid Glass Checklist

Liquid Glass is where custom styling most often goes wrong, so check these for any component that uses `glassEffect` or a glass button style:

- **Layer:** Use Liquid Glass on the controls and navigation layer that floats above content, not inside the content layer. Use standard materials for content surfaces such as cards and backgrounds.
- **Variant:** Default to `.regular`. Use `.clear` only over visually rich media such as photos, video or maps, with a dark dimming layer (about 35%) when the background is bright.
- **Colour:** Liquid Glass has no colour of its own. Leave it untinted by default. Tint only to emphasise a primary action, using the accent colour on the background (the system prominent style), and don't tint several controls in one view.
- **Labels:** Keep labels monochrome over colourful content. Use a vibrant label role that adapts to what's behind the glass rather than a fixed colour.
- **Edges:** Don't add custom strokes or shadows; the material draws its own edge highlight and shadow.
- **Interaction:** Add `.interactive()` to glass that behaves like a button, so it responds to touch. Leave it off containers and text inputs.
- **Restraint:** Use custom glass sparingly, only on the most important functional elements.

**AI Rule:**
Reject Liquid Glass usage that adds neutral tints, custom rims or shadows, or glass in the content layer without an HIG-backed reason stated in the change.

---

## 6. Worked Example: Glass Button Tint

This is the reasoning that led to the untinted glass button in PR #18, as a template for future reviews.

1. **Observation:** The glass `Button` looked milkier than the bottom search bar, although both used `.glassEffect(.regular, in: .capsule)`.
2. **Code check:** The button added `.tint(Color.button.glass.tint)`, a 22% white (light) / 28% near-black (dark) wash. The search bar added a hand-drawn white stroke and a black drop shadow.
3. **HIG check:** [Color › Liquid Glass color](https://developer.apple.com/design/human-interface-guidelines/color#Liquid-Glass-color) says glass takes its colour from the content behind it, tint is for emphasising a primary action, and colour shouldn't go on many control backgrounds at once. [Materials](https://developer.apple.com/design/human-interface-guidelines/materials) says the material provides its own edge treatment and should be used sparingly.
4. **Conclusion:** The neutral tint contradicted the HIG, and the search bar's extra rim and shadow duplicated what the material already draws.
5. **Change:** Remove the tint from Figma and code together (the `color/button/glassTint` token was deleted), move the glass label to the `color/labels-vibrant/primary` role, and drop the search bar's custom stroke and shadow.

Follow the same order: observe, read the code, read the HIG page, state the gap with a citation, then change Figma and code together.
