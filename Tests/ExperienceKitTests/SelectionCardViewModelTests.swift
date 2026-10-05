import XCTest
@testable import ExperienceKit

final class SelectionCardViewModelTests: XCTestCase {
    func testKeepsProvidedValue() {
        let viewModel = makeViewModel(value: "£39.99")

        XCTAssertEqual(viewModel.value, "£39.99")
    }

    func testNilValueSelectsChoiceCardLayout() {
        let viewModel = makeViewModel(value: nil)

        XCTAssertNil(viewModel.value)
    }

    func testEmptyValueIsTreatedAsNoValue() {
        let viewModel = makeViewModel(value: "")

        XCTAssertNil(viewModel.value)
    }

    func testEmptyBadgeTextHidesBadge() {
        let viewModel = makeViewModel(value: nil, badgeText: "")

        XCTAssertNil(viewModel.badgeText)
    }

    func testBadgeStyleDefaultsToProminent() {
        let viewModel = makeViewModel(value: "£39.99", badgeText: "Save 44%")

        XCTAssertEqual(viewModel.badgeStyle, .prominent)
    }

    func testUsesProvidedBadgeStyle() {
        let viewModel = makeViewModel(value: nil, badgeText: "Flat", badgeStyle: .neutral)

        XCTAssertEqual(viewModel.badgeStyle, .neutral)
    }

    func testDecodingWithoutValueOrBadgeStyleUsesDefaults() throws {
        let json = """
        {
            "title": "Same every day",
            "subtitle": "One target, seven days a week.",
            "isSelected": false,
            "selectionMode": "single"
        }
        """

        let properties = try JSONDecoder().decode(SelectionCardProperties.self, from: Data(json.utf8))

        XCTAssertNil(properties.value)
        XCTAssertNil(properties.badgeText)
        XCTAssertEqual(properties.badgeStyle, .prominent)
    }

    func testDecodingNeutralBadgeStyle() throws {
        let json = """
        {
            "title": "Carb cycling",
            "subtitle": "Five lighter days and two at full maintenance.",
            "isSelected": true,
            "badgeText": "5 low · 2 high",
            "badgeStyle": "neutral",
            "selectionMode": "single"
        }
        """

        let properties = try JSONDecoder().decode(SelectionCardProperties.self, from: Data(json.utf8))

        XCTAssertEqual(properties.badgeText, "5 low · 2 high")
        XCTAssertEqual(properties.badgeStyle, .neutral)
    }

    func testDecodesOnChangeWorkId() throws {
        let json = """
        {
            "title": "Carb cycling",
            "subtitle": "Five lighter days and two at full maintenance.",
            "isSelected": true,
            "selectionMode": "single",
            "onChangeWorkId": "weeklySplitChanged"
        }
        """

        let properties = try JSONDecoder().decode(SelectionCardProperties.self, from: Data(json.utf8))

        XCTAssertEqual(properties.onChangeWorkId?.rawValue, "weeklySplitChanged")
    }

    func testSingleSelectionSendsOnChangeWorkWithTheSelectedCard() {
        let delegate = PresenterNotifierDelegateSpy()
        let groupId = UUID().uuidString
        let monthly = makeSelectableViewModel(selectionId: "monthly", isSelected: true, groupId: groupId, delegate: delegate)
        let yearly = makeSelectableViewModel(selectionId: "yearly", groupId: groupId, delegate: delegate)

        yearly.select()

        XCTAssertFalse(monthly.isSelected)
        XCTAssertTrue(yearly.isSelected)
        XCTAssertEqual(delegate.deferredWork, [.init(workId: "selectionChanged", values: ["yearly"])])
    }

    func testReselectingTheSelectedCardSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()
        let groupId = UUID().uuidString
        let monthly = makeSelectableViewModel(selectionId: "monthly", isSelected: true, groupId: groupId, delegate: delegate)

        monthly.select()

        XCTAssertTrue(monthly.isSelected)
        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testMultipleSelectionSendsEverySelectedCardInTheGroup() {
        let delegate = PresenterNotifierDelegateSpy()
        let groupId = UUID().uuidString
        let backups = makeSelectableViewModel(selectionId: "backups", groupId: groupId, mode: .multiple, delegate: delegate)
        let support = makeSelectableViewModel(selectionId: "support", groupId: groupId, mode: .multiple, delegate: delegate)

        backups.select()
        support.select()
        backups.select()

        XCTAssertEqual(delegate.deferredWork.map(\.values), [["backups"], ["backups", "support"], ["support"]])
    }

    func testStandaloneMultipleSelectionSendsAnEmptyListWhenDeselected() {
        let delegate = PresenterNotifierDelegateSpy()
        let newsletter = makeSelectableViewModel(selectionId: "newsletter", groupId: nil, mode: .multiple, delegate: delegate)

        newsletter.select()
        newsletter.select()

        XCTAssertEqual(delegate.deferredWork.map(\.values), [["newsletter"], []])
    }

    func testCreatingASelectedCardSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()

        _ = makeSelectableViewModel(selectionId: "monthly", isSelected: true, groupId: UUID().uuidString, delegate: delegate)

        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    func testSelectionWithoutOnChangeWorkIdSendsNoWork() {
        let delegate = PresenterNotifierDelegateSpy()
        let yearly = makeSelectableViewModel(selectionId: "yearly",
                                             groupId: nil,
                                             onChangeWorkId: nil,
                                             delegate: delegate)

        yearly.select()

        XCTAssertTrue(yearly.isSelected)
        XCTAssertTrue(delegate.deferredWork.isEmpty)
    }

    private func makeSelectableViewModel(selectionId: String,
                                         isSelected: Bool = false,
                                         groupId: String?,
                                         mode: SelectionCardProperties.SelectionMode = .single,
                                         onChangeWorkId: (any DeferredWorkID)? = SelectionCardTestWorkID.selectionChanged,
                                         delegate: ExperiencePresenterNotifierDelegate) -> SelectionCardViewModel {
        makeViewModel(value: nil,
                      isSelected: isSelected,
                      selectionId: selectionId,
                      selectionGroupId: groupId,
                      selectionMode: mode,
                      onChangeWorkId: onChangeWorkId,
                      delegate: delegate)
    }

    private func makeViewModel(value: String?,
                               badgeText: String? = nil,
                               badgeStyle: SelectionCardProperties.BadgeStyle = .prominent,
                               isSelected: Bool = false,
                               selectionId: String? = nil,
                               selectionGroupId: String? = nil,
                               selectionMode: SelectionCardProperties.SelectionMode = .single,
                               onChangeWorkId: (any DeferredWorkID)? = nil,
                               delegate: ExperiencePresenterNotifierDelegate? = nil) -> SelectionCardViewModel {
        let notifier = DefaultExperiencePresenterNotifier()
        notifier.delegate = delegate

        return SelectionCardViewModel(
            properties: .init(title: "Yearly",
                              subtitle: "£3.33 a month, billed once",
                              value: value,
                              isSelected: isSelected,
                              badgeText: badgeText,
                              badgeStyle: badgeStyle,
                              selectionId: selectionId,
                              selectionGroupId: selectionGroupId,
                              selectionMode: selectionMode,
                              onChangeWorkId: onChangeWorkId,
                              navigation: nil),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: SelectionCardTestExperienceID.root),
                experiencePresenterNotifier: notifier,
                viewProvider: ViewProvider(supportedComponentRegisters: []),
                viewModelProvider: DefaultViewModelProvider(supportedComponentRegisters: [])
            ),
            id: UUID()
        )
    }
}

private enum SelectionCardTestExperienceID: String, ExperienceID {
    case root
}

private enum SelectionCardTestWorkID: String, DeferredWorkID {
    case selectionChanged
}
