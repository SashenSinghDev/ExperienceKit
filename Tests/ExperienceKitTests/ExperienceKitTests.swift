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

    func testDismissWithoutDelegateKeepsPresenterCache() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        let presenter = NSObject()
        let presenterID = UUID()

        router.storePresenter(presenter, for: presenterID)

        router.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                deferredLoadingWorkId: nil,
                                                experienceViewModel: nil))

        let cachedPresenter: NSObject? = router.presenter(for: presenterID)
        XCTAssertTrue(cachedPresenter === presenter)
    }

    func testDismissWithDelegateDismissesModal() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        let delegate = DismissDelegateSpy()
        router.delegate = delegate

        router.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                deferredLoadingWorkId: nil,
                                                experienceViewModel: nil))

        XCTAssertEqual(delegate.dismissCallCount, 1)
    }

    func testDismissWithDelegateClearsPresenterCache() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        let delegate = DismissDelegateSpy()
        router.delegate = delegate
        let presenterID = UUID()

        router.storePresenter(NSObject(), for: presenterID)

        router.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                deferredLoadingWorkId: nil,
                                                experienceViewModel: nil))

        let cachedPresenter: NSObject? = router.presenter(for: presenterID)
        XCTAssertNil(cachedPresenter)
    }
}

private enum TestExperienceID: String, ExperienceID {
    case root
}

private final class DismissDelegateSpy: ExperienceRouterDelegate {
    private(set) var dismissCallCount = 0

    func dismissModal() {
        dismissCallCount += 1
    }
}
