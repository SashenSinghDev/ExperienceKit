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

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    func finishAsyncWork() {
        loadCompletion?(.navigateImmediately(navigationViewModel: .init(
            navigationType: .push(PresenterTestExperienceID.next),
            deferredLoadingWorkId: nil,
            experienceViewModel: nil)))
    }
}
