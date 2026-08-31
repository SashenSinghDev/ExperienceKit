import XCTest
@testable import ExperienceKit

final class DefaultExperienceRouterTests: XCTestCase {
    func testPushPopAndPopToRootUpdatesPathInOrder() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)
        let first = makeNavigationViewModel(.push(TestExperienceID.firstPushed))
        let second = makeNavigationViewModel(.push(TestExperienceID.secondPushed))
        let third = makeNavigationViewModel(.push(TestExperienceID.thirdPushed))

        router.navigate(to: first)
        router.navigate(to: second)
        router.navigate(to: makeNavigationViewModel(.pop))
        router.navigate(to: third)

        XCTAssertEqual(router.path, [first, third])

        router.navigate(to: makeNavigationViewModel(.popToRoot))

        XCTAssertTrue(router.path.isEmpty)
    }

    func testPopOnEmptyPathLeavesPathEmpty() {
        let router = DefaultExperienceRouter(expId: TestExperienceID.root)

        router.navigate(to: makeNavigationViewModel(.pop))

        XCTAssertTrue(router.path.isEmpty)
    }

    func testDismissFromPresentedRouterClearsParentModalWithoutChangingParentPath() {
        let parentRouter = DefaultExperienceRouter(expId: TestExperienceID.root)
        let presentedRouter = DefaultExperienceRouter(expId: TestExperienceID.modal)
        let pushed = makeNavigationViewModel(.push(TestExperienceID.firstPushed))
        let modal = makeNavigationViewModel(.modal(TestExperienceID.modal))

        parentRouter.navigate(to: pushed)
        parentRouter.navigate(to: modal)
        presentedRouter.delegate = parentRouter

        presentedRouter.navigate(to: makeNavigationViewModel(.dismiss))

        XCTAssertEqual(parentRouter.path, [pushed])
        XCTAssertNil(parentRouter.navigationViewModel)
    }

    func testPushPopPopToRootAndDismissCombinationReleasesCachedExperiencePresenters() {
        weak var weakParentRouter: DefaultExperienceRouter?
        weak var weakPresentedRouter: DefaultExperienceRouter?
        weak var weakFirstPushedPresenter: ExperiencePresenter?
        weak var weakSecondPushedPresenter: ExperiencePresenter?
        weak var weakModalPresenter: ExperiencePresenter?

        autoreleasepool {
            var parentRouter: DefaultExperienceRouter? = DefaultExperienceRouter(expId: TestExperienceID.root)
            var presentedRouter: DefaultExperienceRouter? = DefaultExperienceRouter(expId: TestExperienceID.modal)
            let firstPushed = makeNavigationViewModel(.push(TestExperienceID.firstPushed))
            let secondPushed = makeNavigationViewModel(.push(TestExperienceID.secondPushed))
            let firstPushedPresenter = makePresenter(router: parentRouter!)
            let secondPushedPresenter = makePresenter(router: parentRouter!)
            let modalPresenter = makePresenter(router: presentedRouter!)

            weakParentRouter = parentRouter
            weakPresentedRouter = presentedRouter
            weakFirstPushedPresenter = firstPushedPresenter
            weakSecondPushedPresenter = secondPushedPresenter
            weakModalPresenter = modalPresenter

            parentRouter?.navigate(to: firstPushed)
            parentRouter?.storePresenter(firstPushedPresenter, for: firstPushed.id)
            parentRouter?.navigate(to: secondPushed)
            parentRouter?.storePresenter(secondPushedPresenter, for: secondPushed.id)

            parentRouter?.navigate(to: makeNavigationViewModel(.pop))
            parentRouter?.removePresenter(for: secondPushed.id)

            parentRouter?.navigate(to: makeNavigationViewModel(.popToRoot))
            parentRouter?.removePresenter(for: firstPushed.id)

            parentRouter?.navigate(to: makeNavigationViewModel(.modal(TestExperienceID.modal)))
            presentedRouter?.delegate = parentRouter
            presentedRouter?.storePresenter(modalPresenter, for: UUID())
            presentedRouter?.navigate(to: makeNavigationViewModel(.dismiss))

            presentedRouter = nil
            parentRouter = nil
        }

        XCTAssertNil(weakFirstPushedPresenter)
        XCTAssertNil(weakSecondPushedPresenter)
        XCTAssertNil(weakModalPresenter)
        XCTAssertNil(weakPresentedRouter)
        XCTAssertNil(weakParentRouter)
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

    func testRemovePresenterReleasesCachedExperiencePresenter() {
        weak var weakRouter: DefaultExperienceRouter?
        weak var weakPresenter: ExperiencePresenter?

        autoreleasepool {
            var router: DefaultExperienceRouter? = DefaultExperienceRouter(expId: TestExperienceID.root)
            let presenterID = UUID()
            let presenter = makePresenter(router: router!)

            weakRouter = router
            weakPresenter = presenter

            router?.storePresenter(presenter, for: presenterID)
            router?.removePresenter(for: presenterID)
            router = nil
        }

        XCTAssertNil(weakPresenter)
        XCTAssertNil(weakRouter)
    }

    func testDismissWithDelegateReleasesCachedExperiencePresenters() {
        weak var weakRouter: DefaultExperienceRouter?
        weak var weakFirstPresenter: ExperiencePresenter?
        weak var weakSecondPresenter: ExperiencePresenter?

        autoreleasepool {
            var router: DefaultExperienceRouter? = DefaultExperienceRouter(expId: TestExperienceID.root)
            let delegate = DismissDelegateSpy()
            router?.delegate = delegate

            let firstPresenter = makePresenter(router: router!)
            let secondPresenter = makePresenter(router: router!)

            weakRouter = router
            weakFirstPresenter = firstPresenter
            weakSecondPresenter = secondPresenter

            router?.storePresenter(firstPresenter, for: UUID())
            router?.storePresenter(secondPresenter, for: UUID())

            router?.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                     deferredLoadingWorkId: nil,
                                                     experienceViewModel: nil))
            router = nil
        }

        XCTAssertNil(weakFirstPresenter)
        XCTAssertNil(weakSecondPresenter)
        XCTAssertNil(weakRouter)
    }

    func testDismissFromPresentedRouterReleasesPresentedRouterAndPresenter() {
        weak var weakParentRouter: DefaultExperienceRouter?
        weak var weakPresentedRouter: DefaultExperienceRouter?
        weak var weakPresentedPresenter: ExperiencePresenter?

        autoreleasepool {
            var parentRouter: DefaultExperienceRouter? = DefaultExperienceRouter(expId: TestExperienceID.root)
            var presentedRouter: DefaultExperienceRouter? = DefaultExperienceRouter(expId: TestExperienceID.modal)
            let presenter = makePresenter(router: presentedRouter!)

            weakParentRouter = parentRouter
            weakPresentedRouter = presentedRouter
            weakPresentedPresenter = presenter

            parentRouter?.navigate(to: NavigationViewModel(navigationType: .modal(TestExperienceID.modal),
                                                           deferredLoadingWorkId: nil,
                                                           experienceViewModel: nil))
            presentedRouter?.delegate = parentRouter
            presentedRouter?.storePresenter(presenter, for: UUID())

            presentedRouter?.navigate(to: NavigationViewModel(navigationType: .dismiss,
                                                              deferredLoadingWorkId: nil,
                                                              experienceViewModel: nil))

            presentedRouter = nil
            parentRouter = nil
        }

        XCTAssertNil(weakPresentedPresenter)
        XCTAssertNil(weakPresentedRouter)
        XCTAssertNil(weakParentRouter)
    }

    private func makePresenter(router: DefaultExperienceRouter) -> ExperiencePresenter {
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: [])
        let viewProvider = ViewProvider(supportedComponentRegisters: [])
        let dependency = ExperienceDependency(router: router,
                                              experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                                              viewProvider: viewProvider,
                                              viewModelProvider: viewModelProvider)

        return ExperiencePresenter(viewModelProvider: viewModelProvider,
                                   experienceInteractor: ExperienceInteractorStub(),
                                   dependency: dependency)
    }

    private func makeNavigationViewModel(_ navigationType: NavigationType) -> NavigationViewModel {
        NavigationViewModel(navigationType: navigationType,
                            deferredLoadingWorkId: nil,
                            experienceViewModel: nil)
    }
}

private enum TestExperienceID: String, ExperienceID {
    case root
    case modal
    case firstPushed
    case secondPushed
    case thirdPushed
}

private final class DismissDelegateSpy: ExperienceRouterDelegate {
    private(set) var dismissCallCount = 0

    func dismissModal() {
        dismissCallCount += 1
    }
}

private final class ExperienceInteractorStub: ExperienceInteractor {
    let experienceViewModel: ExperienceViewModel? = nil

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: []))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }
}
