@testable import ExperienceKit

/// Records what component view models send to the presenter.
final class PresenterNotifierDelegateSpy: ExperiencePresenterNotifierDelegate {
    struct DeferredWork: Equatable {
        let workId: String
        let values: [String]
    }

    private(set) var deferredWork: [DeferredWork] = []
    private(set) var navigationViewModels: [NavigationViewModel] = []

    func navigate(navigationViewModel: NavigationViewModel) {
        navigationViewModels.append(navigationViewModel)
    }

    func performDeferredWork(workId: any DeferredWorkID, values: [String]) {
        deferredWork.append(.init(workId: workId.rawValue, values: values))
    }
}
