import XCTest
@testable import ExperienceKit

final class ExperiencePresenterTests: XCTestCase {
    func testLoadCompletionCanRenderThenNavigateWithoutUserAction() {
        let router = DefaultExperienceRouter(expId: PresenterTestExperienceID.root)
        let interactor = RenderThenNavigateInteractor()
        let presenter = makePresenter(router: router, interactor: interactor)

        presenter.load()

        guard case .loadedFullScreen = presenter.state else {
            return XCTFail("Expected the screen to render before navigating")
        }
        XCTAssertTrue(router.path.isEmpty)

        interactor.finishAsyncWork()

        XCTAssertEqual(router.path.map(\.navigationType), [.push(PresenterTestExperienceID.next)])
        guard case .loadedFullScreen = presenter.state else {
            return XCTFail("Expected the rendered screen to stay in place after navigating")
        }
    }

    func testComponentDeferredWorkReachesTheInteractorWithItsValues() {
        let router = DefaultExperienceRouter(expId: PresenterTestExperienceID.root)
        let interactor = RecordingInteractor()
        let presenter = makePresenter(router: router, interactor: interactor)

        presenter.performDeferredWork(workId: PresenterTestWorkID.unitsChanged, values: ["imperial"])

        XCTAssertEqual(interactor.workIds, ["unitsChanged"])
        XCTAssertEqual(interactor.values, [["imperial"]])
    }

    func testComponentDeferredWorkDoesNotShowLoadingOrNavigate() {
        let router = DefaultExperienceRouter(expId: PresenterTestExperienceID.root)
        let interactor = RecordingInteractor()
        interactor.completesImmediately = false
        let presenter = makePresenter(router: router, interactor: interactor)

        presenter.performDeferredWork(workId: PresenterTestWorkID.unitsChanged, values: ["imperial"])

        XCTAssertFalse(router.isLoading)
        XCTAssertTrue(router.path.isEmpty)
    }

    func testComponentDeferredWorkKeepsTheScreenWhenTheInteractorReturnsNil() {
        let router = DefaultExperienceRouter(expId: PresenterTestExperienceID.root)
        let interactor = RecordingInteractor()
        let presenter = makePresenter(router: router, interactor: interactor)
        presenter.load()

        presenter.performDeferredWork(workId: PresenterTestWorkID.unitsChanged, values: ["imperial"])

        guard case .loadedScrollable = presenter.state else {
            return XCTFail("Expected the loaded screen to stay in place")
        }
    }

    func testComponentDeferredWorkRendersAReturnedExperience() {
        let router = DefaultExperienceRouter(expId: PresenterTestExperienceID.root)
        let interactor = RecordingInteractor()
        interactor.deferredWorkResult = .fullScreen(properties: .init(image: nil,
                                                                      topComponents: [],
                                                                      middleComponents: [],
                                                                      bottomComponents: []))
        let presenter = makePresenter(router: router, interactor: interactor)
        presenter.load()

        presenter.performDeferredWork(workId: PresenterTestWorkID.unitsChanged, values: ["imperial"])

        guard case .loadedFullScreen = presenter.state else {
            return XCTFail("Expected the returned experience to replace the screen")
        }
    }

    func testNavigationDeferredWorkCarriesNoValues() {
        let router = DefaultExperienceRouter(expId: PresenterTestExperienceID.root)
        let interactor = RecordingInteractor()
        let presenter = makePresenter(router: router, interactor: interactor)

        presenter.navigate(navigationViewModel: .init(navigationType: .push(PresenterTestExperienceID.next),
                                                      deferredLoadingWorkId: PresenterTestWorkID.continue,
                                                      experienceViewModel: nil))

        XCTAssertEqual(interactor.workIds, ["continue"])
        XCTAssertEqual(interactor.values, [[]])
        XCTAssertEqual(router.path.map(\.navigationType), [.push(PresenterTestExperienceID.next)])
    }

    private func makePresenter(router: DefaultExperienceRouter,
                               interactor: ExperienceInteractor) -> ExperiencePresenter {
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: [])
        let dependency = ExperienceDependency(router: router,
                                              experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                                              viewProvider: ViewProvider(supportedComponentRegisters: []),
                                              viewModelProvider: viewModelProvider)

        return ExperiencePresenter(viewModelProvider: viewModelProvider,
                                   experienceInteractor: interactor,
                                   dependency: dependency)
    }
}

private enum PresenterTestExperienceID: String, ExperienceID {
    case root
    case next
}

private enum PresenterTestWorkID: String, DeferredWorkID {
    case `continue`
    case unitsChanged
}

/// Records the deferred work it is asked to perform.
private final class RecordingInteractor: ExperienceInteractor {
    let experienceViewModel: ExperienceViewModel? = nil
    private(set) var workIds: [String] = []
    private(set) var values: [[String]] = []
    var deferredWorkResult: ExperienceType?
    var completesImmediately = true

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: []))
    }

    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void) {
        workIds.append(workId.rawValue)
        self.values.append(values)

        if completesImmediately {
            completion(deferredWorkResult)
        }
    }
}

/// Renders a screen from `load`, then navigates when its async work finishes.
private final class RenderThenNavigateInteractor: ExperienceInteractor {
    let experienceViewModel: ExperienceViewModel? = nil
    private var loadCompletion: ((ExperienceType) -> Void)?

    func load(completion: @escaping (ExperienceType) -> Void) {
        loadCompletion = completion
        completion(.fullScreen(properties: .init(image: nil,
                                                 topComponents: [],
                                                 middleComponents: [],
                                                 bottomComponents: [])))
    }

    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    func finishAsyncWork() {
        loadCompletion?(.navigateImmediately(navigationViewModel: .init(
            navigationType: .push(PresenterTestExperienceID.next),
            deferredLoadingWorkId: nil,
            experienceViewModel: nil)))
    }
}
