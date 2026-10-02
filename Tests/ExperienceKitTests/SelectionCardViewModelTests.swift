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

    private func makeViewModel(value: String?,
                               badgeText: String? = nil,
                               badgeStyle: SelectionCardProperties.BadgeStyle = .prominent) -> SelectionCardViewModel {
        SelectionCardViewModel(
            properties: .init(title: "Yearly",
                              subtitle: "£3.33 a month, billed once",
                              value: value,
                              isSelected: false,
                              badgeText: badgeText,
                              badgeStyle: badgeStyle,
                              navigation: nil),
            dependency: ExperienceDependency(
                router: DefaultExperienceRouter(expId: SelectionCardTestExperienceID.root),
                experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
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
