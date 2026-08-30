import XCTest
@testable import ExperienceKit

final class ExperienceKitTests: XCTestCase {
    func testMissingExperienceViewModelUsesInlineDisplayMode() {
        let presentation = NavigationBarPresentation(experienceViewModel: nil)

        XCTAssertEqual(presentation.title, "")
        XCTAssertEqual(presentation.displayMode, .inline)
    }

    func testExperienceViewModelPresentationUsesProvidedValues() {
        let presentation = NavigationBarPresentation(
            experienceViewModel: ExperienceViewModel(
                searchBar: nil,
                navigationBar: .init(title: "Navigation", displayMode: .large)
            )
        )

        XCTAssertEqual(presentation.title, "Navigation")
        XCTAssertEqual(presentation.displayMode, .large)
    }
}
