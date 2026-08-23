import XCTest
@testable import ExperienceKit

final class ExperienceKitTests: XCTestCase {
    func testDismissWithoutDelegateKeepsPresenterCache() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        let presenter = NSObject()
        let presenterID = UUID()

        router.storePresenter(presenter, for: presenterID)

        router.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                deferredLoadingWorkId: nil,
                                                properties: nil,
                                                navigationBarModel: nil))

        let cachedPresenter: NSObject? = router.presenter(for: presenterID)
        XCTAssertTrue(cachedPresenter === presenter)
    }

    func testDismissWithDelegateDismissesModal() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        let delegate = DismissDelegateSpy()
        router.delegate = delegate

        router.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                deferredLoadingWorkId: nil,
                                                properties: nil,
                                                navigationBarModel: nil))

        XCTAssertEqual(delegate.dismissCallCount, 1)
    }

    func testDismissWithDelegateClearsPresenterCache() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        router.delegate = DismissDelegateSpy()
        let presenterID = UUID()

        router.storePresenter(NSObject(), for: presenterID)

        router.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                deferredLoadingWorkId: nil,
                                                properties: nil,
                                                navigationBarModel: nil))

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
