import Combine
import XCTest
@testable import ExperienceKit

final class ValidationMessageViewModelTests: XCTestCase {
    private let fields: [ValidationMessageProperties.Field] = [
        .init(name: "weight", selectionKey: "weight"),
        .init(name: "height", selectionKey: "height"),
        .init(name: "age", selectionKey: "age")
    ]

    func testListsEveryMissingField() {
        let viewModel = makeViewModel(store: MessageSelectionStateStore())

        XCTAssertEqual(viewModel.message, "Add your weight, height and age to continue.")
    }

    func testFieldDropsOutOnceItHasAValue() {
        let store = MessageSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("88", for: "weight")

        XCTAssertEqual(viewModel.message, "Add your height and age to continue.")
    }

    func testMessageHidesWhenEveryFieldHasAValue() {
        let store = MessageSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("88", for: "weight")
        store.setSelectedValue("180", for: "height")
        store.setSelectedValue("32", for: "age")

        XCTAssertNil(viewModel.message)
    }

    func testWhitespaceDoesNotCountAsAValue() {
        let store = MessageSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("  ", for: "weight")

        XCTAssertEqual(viewModel.message, "Add your weight, height and age to continue.")
    }

    func testEmptyingAFieldAgainDoesNotBringItBack() {
        let store = MessageSelectionStateStore()
        let viewModel = makeViewModel(store: store)

        store.setSelectedValue("88", for: "weight")
        store.setSelectedValue("", for: "weight")

        XCTAssertEqual(viewModel.message, "Add your height and age to continue.")
    }

    func testFieldsWithValuesAtCreationAreLeftOut() {
        let store = MessageSelectionStateStore()
        store.setSelectedValue("88", for: "weight")

        let viewModel = makeViewModel(store: store)

        XCTAssertEqual(viewModel.message, "Add your height and age to continue.")
    }

    func testSingleFieldUsesItsNameAlone() {
        XCTAssertEqual(
            ValidationMessageViewModel.message(for: [fields[2]], template: "Add your {fields}.", conjunction: "and"),
            "Add your age."
        )
    }

    func testConjunctionIsConfigurable() {
        XCTAssertEqual(
            ValidationMessageViewModel.message(for: Array(fields.prefix(2)), template: "{fields}", conjunction: "et"),
            "weight et height"
        )
    }

    func testObservedStoreForwardsAndPublishesWrites() {
        let base = MessageSelectionStateStore()
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

    private func makeViewModel(store: MessageSelectionStateStore) -> ValidationMessageViewModel {
        ValidationMessageViewModel(
            properties: .init(fields: fields, template: "Add your {fields} to continue."),
            dependency: MessageDependency(store: store),
            id: UUID()
        )
    }
}

private struct MessageDependency: HasExperienceSelectionStateStore, HasExperienceSelectionChanges {
    let experienceSelectionStateStore: ExperienceSelectionStateStore?
    let experienceSelectionChanges: AnyPublisher<String, Never>

    init(store: MessageSelectionStateStore) {
        self.experienceSelectionStateStore = store
        self.experienceSelectionChanges = store.changes.eraseToAnyPublisher()
    }
}

/// Publishes writes directly, standing in for the observed wrapper ExperienceDependency adds.
private final class MessageSelectionStateStore: ExperienceSelectionStateStore {
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
