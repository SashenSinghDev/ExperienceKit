import Combine
import XCTest
@testable import ExperienceKit

final class TextViewModelTests: XCTestCase {
    private let fields: [TextProperties.MissingSelections.Field] = [
        .init(name: "weight", selectionKey: "weight"),
        .init(name: "height", selectionKey: "height"),
        .init(name: "age", selectionKey: "age")
    ]

    func testPlainTextShowsTitleAsIs() {
        let viewModel = TextViewModel(
            properties: .init(title: "Add your {fields}", font: .body, weight: .regular,
                              alignment: .leading, foregroundStyle: .primary),
            dependency: TextDependency(store: TextSelectionStateStore()),
            id: UUID()
        )

        XCTAssertEqual(viewModel.title, "Add your {fields}")
    }

    func testListsEveryMissingField() {
        let viewModel = makeViewModel(store: TextSelectionStateStore())

        XCTAssertEqual(viewModel.title, "Add your weight, height and age to continue.")
    }

    func testFieldDropsOutOnceItHasAValue() {
        let store = TextSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("88", for: "weight")

        XCTAssertEqual(viewModel.title, "Add your height and age to continue.")
    }

    func testTextHidesWhenEveryFieldHasAValue() {
        let store = TextSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("88", for: "weight")
        store.setSelectedValue("180", for: "height")
        store.setSelectedValue("32", for: "age")

        XCTAssertNil(viewModel.title)
    }

    func testWhitespaceDoesNotCountAsAValue() {
        let store = TextSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("  ", for: "weight")

        XCTAssertEqual(viewModel.title, "Add your weight, height and age to continue.")
    }

    func testEmptyingAFieldAgainDoesNotBringItBack() {
        let store = TextSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("88", for: "weight")
        store.setSelectedValue("", for: "weight")

        XCTAssertEqual(viewModel.title, "Add your height and age to continue.")
    }

    func testFieldsWithValuesAtCreationAreLeftOut() {
        let store = TextSelectionStateStore()
        store.setSelectedValue("88", for: "weight")

        let viewModel = makeViewModel(store: store)

        XCTAssertEqual(viewModel.title, "Add your height and age to continue.")
    }

    func testSingleFieldUsesItsNameAlone() {
        XCTAssertEqual(
            TextViewModel.title(template: "Add your {fields}.",
                                missingSelections: .init(fields: fields),
                                remainingFields: [fields[2]]),
            "Add your age."
        )
    }

    func testConjunctionIsConfigurable() {
        XCTAssertEqual(
            TextViewModel.title(template: "{fields}",
                                missingSelections: .init(fields: fields, conjunction: "et"),
                                remainingFields: Array(fields.prefix(2))),
            "weight et height"
        )
    }

    func testObservedStoreForwardsAndPublishesWrites() {
        let base = TextSelectionStateStore()
        let observed = ObservedExperienceSelectionStateStore(base: base)
        var keys: [String] = []
        let cancellable = observed.changes.sink { keys.append($0) }

        observed.setSelectedValue("88", for: "weight")
        observed.addSelectedValue("a", for: "tags")
        observed.removeSelectedValue("a", for: "tags")

        XCTAssertEqual(base.selectedValues(for: "weight"), ["88"])
        XCTAssertEqual(keys, ["weight", "tags", "tags"])
        cancellable.cancel()
    }

    private func makeViewModel(store: TextSelectionStateStore) -> TextViewModel {
        TextViewModel(
            properties: .init(title: "Add your {fields} to continue.", font: .footnote,
                              weight: .regular, alignment: .leading, foregroundStyle: .error,
                              missingSelections: .init(fields: fields)),
            dependency: TextDependency(store: store),
            id: UUID()
        )
    }
}

private struct TextDependency: HasExperienceSelectionStateStore, HasExperienceSelectionChanges {
    let experienceSelectionStateStore: ExperienceSelectionStateStore?
    let experienceSelectionChanges: AnyPublisher<String, Never>

    init(store: TextSelectionStateStore) {
        self.experienceSelectionStateStore = store
        self.experienceSelectionChanges = store.changes.eraseToAnyPublisher()
    }
}

/// Publishes writes directly, standing in for the observed wrapper ExperienceDependency adds.
private final class TextSelectionStateStore: ExperienceSelectionStateStore {
    let changes = PassthroughSubject<String, Never>()
    private var values: [String: [String]] = [:]

    func setSelectedValue(_ value: String, for key: String) {
        values[key] = [value]
        changes.send(key)
    }

    func addSelectedValue(_ value: String, for key: String) {
        values[key, default: []].append(value)
        changes.send(key)
    }

    func removeSelectedValue(_ value: String, for key: String) {
        values[key]?.removeAll { $0 == value }
        changes.send(key)
    }

    func selectedValues(for key: String) -> [String] {
        values[key] ?? []
    }
}
