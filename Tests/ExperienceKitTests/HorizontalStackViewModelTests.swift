import XCTest
@testable import ExperienceKit

final class HorizontalStackViewModelTests: XCTestCase {
    func testCreatesAChildViewModelForEachComponentInOrder() {
        let components = [text("One"), text("Two"), text("Three")]

        let viewModel = makeViewModel(components: components)

        XCTAssertEqual(viewModel.children.map(\.id), components.map(\.id))
        XCTAssertEqual(viewModel.children.map(\.contentType), ["text", "text", "text"])
    }

    func testDefaultsToSmallSpacingTopAlignmentAndFillEqually() {
        let viewModel = makeViewModel(components: [text("One")])

        XCTAssertEqual(viewModel.spacing, 8)
        XCTAssertEqual(viewModel.alignment, .top)
        XCTAssertEqual(viewModel.distribution, .fillEqually)
    }

    func testMapsSpacingToDesignSystemTokens() {
        XCTAssertEqual(makeViewModel(components: [], spacing: .none).spacing, 0)
        XCTAssertEqual(makeViewModel(components: [], spacing: .small).spacing, 8)
        XCTAssertEqual(makeViewModel(components: [], spacing: .medium).spacing, 16)
        XCTAssertEqual(makeViewModel(components: [], spacing: .large).spacing, 32)
    }

    func testChildrenReceiveTheSessionSelectionStateStore() {
        let store = HorizontalStackSelectionStateStore()

        _ = makeViewModel(
            components: [
                .textfieldComponent(properties: .init(
                    state: .filled,
                    placeholder: "Weight",
                    value: "88",
                    selectionKey: "weight"
                ))
            ],
            store: store
        )

        XCTAssertEqual(store.selectedValues(for: "weight"), ["88"])
    }

    private func makeViewModel(components: [Component],
                               spacing: HorizontalStackProperties.Spacing = .small,
                               store: ExperienceSelectionStateStore? = nil) -> HorizontalStackViewModel {
        let registers: [ComponentRegister] = [TextComponentRegister(), TextFieldComponentRegister()]

        return HorizontalStackViewModel(
            properties: .init(components: components, spacing: spacing),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: HorizontalStackTestExperienceID.root),
                experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                viewProvider: ViewProvider(supportedComponentRegisters: registers),
                viewModelProvider: DefaultViewModelProvider(supportedComponentRegisters: registers),
                experienceSelectionStateStore: store
            ),
            id: UUID()
        )
    }

    private func text(_ title: String) -> Component {
        .textComponent(properties: .init(
            title: title,
            font: .body,
            weight: .regular,
            alignment: .leading,
            foregroundStyle: .primary
        ))
    }
}

private enum HorizontalStackTestExperienceID: String, ExperienceID {
    case root
}

private final class HorizontalStackSelectionStateStore: ExperienceSelectionStateStore {
    private var selectedValuesByKey: [String: [String]] = [:]

    func setSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key] = [value]
    }

    func addSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key, default: []].append(value)
    }

    func removeSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key] = selectedValuesByKey[key, default: []].filter { $0 != value }
    }

    func selectedValues(for key: String) -> [String] {
        selectedValuesByKey[key, default: []]
    }
}
