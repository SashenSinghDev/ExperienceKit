import XCTest
@testable import ExperienceKit

final class TextFieldViewModelTests: XCTestCase {
    func testEmptyStateIgnoresProvidedValue() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .empty,
                placeholder: "Email",
                value: "jordan@example.com"
            ),
            dependency: EmptyTextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.text, "")
        XCTAssertFalse(viewModel.isDisabled)
    }

    func testErrorStateUsesErrorMessage() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .error,
                placeholder: "Email",
                value: "not-an-email",
                helperText: "Helper",
                errorMessage: "Enter a valid email address."
            ),
            dependency: EmptyTextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.message, "Enter a valid email address.")
        XCTAssertTrue(viewModel.showsError)
    }

    func testTextUpdatesSelectionStateStore() {
        let store = TextFieldSelectionStateStore()
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .filled,
                placeholder: "Email",
                value: "jordan@example.com",
                selectionKey: "email"
            ),
            dependency: TextFieldDependency(store: store),
            id: UUID()
        )

        viewModel.updateText("casey@example.com")

        XCTAssertEqual(store.selectedValues(for: "email"), ["casey@example.com"])
    }

    func testKeyboardTypeIsCarriedFromProperties() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .filled,
                keyboardType: .decimalPad,
                placeholder: "Weight",
                value: "93",
                unit: "kg"
            ),
            dependency: EmptyTextFieldDependency(),
            id: UUID()
        )

        XCTAssertEqual(viewModel.keyboardType, .decimalPad)
    }

    func testClearButtonIsShownByDefault() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .focused,
                placeholder: "Search",
                value: "Coffee near me"
            ),
            dependency: EmptyTextFieldDependency(),
            id: UUID()
        )

        XCTAssertTrue(viewModel.showsClearButton)
    }

    func testClearButtonCanBeHidden() {
        let viewModel = TextFieldViewModel(
            properties: .init(
                state: .focused,
                placeholder: "Search",
                value: "Coffee near me",
                showsClearButton: false
            ),
            dependency: EmptyTextFieldDependency(),
            id: UUID()
        )

        XCTAssertFalse(viewModel.showsClearButton)
    }
}

private struct EmptyTextFieldDependency: HasExperienceSelectionStateStore {
    let experienceSelectionStateStore: ExperienceSelectionStateStore? = nil
}

private struct TextFieldDependency: HasExperienceSelectionStateStore {
    let experienceSelectionStateStore: ExperienceSelectionStateStore?

    init(store: ExperienceSelectionStateStore) {
        self.experienceSelectionStateStore = store
    }
}

private final class TextFieldSelectionStateStore: ExperienceSelectionStateStore {
    private var values: [String: [String]] = [:]

    func setSelectedValue(_ value: String, for key: String) {
        values[key] = [value]
    }

    func addSelectedValue(_ value: String, for key: String) {
        values[key, default: []].append(value)
    }

    func removeSelectedValue(_ value: String, for key: String) {
        values[key]?.removeAll { $0 == value }
    }

    func selectedValues(for key: String) -> [String] {
        values[key] ?? []
    }
}
