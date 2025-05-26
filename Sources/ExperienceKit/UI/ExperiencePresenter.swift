//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public final class ExperiencePresenter: ObservableObject {

    public enum State {
        case idle
        case loading
        case failed(Error)
        case loadedScrollable([AnyComponentViewModel])
        case loadedFullScreen(AnyComponentViewModel)
    }

    @Published public var state: State = .idle

    private let viewModelProvider: ViewModelProvider
    private let experienceInteractor: ExperienceInteractor
    private let dependency: ExperienceDependency

    public init(viewModelProvider: ViewModelProvider,
                experienceInteractor: ExperienceInteractor,
                dependency: ExperienceDependency) {
        self.viewModelProvider = viewModelProvider
        self.experienceInteractor = experienceInteractor
        self.dependency = dependency
        dependency.router.delegate = self
    }

    public func load() {
        self.experienceInteractor.load { [weak self] experienceType in

            guard let self else { return }

            switch experienceType {
            case .fullScreen(let component):
                guard let viewModel = self.viewModelProvider.viewModel(for: component, dependency: dependency) else {
                    // TODO: Log this instead
                    fatalError("full screen component not supported")
                }
                self.state = .loadedFullScreen(viewModel)
            case .scrollable(let components):
                let viewModels: [AnyComponentViewModel] = components.compactMap {
                    return self.viewModelProvider.viewModel(for: $0, dependency: self.dependency)
                }

                self.state = .loadedScrollable(viewModels)
            }
        }
    }
}

extension ExperiencePresenter: ExperienceRouterDelegate {
    public func navigate(to navigationViewModel: NavigationViewModel) {
        if let deferredLoadingWorkId = navigationViewModel.deferredLoadingWorkId {
            dependency.router.isLoading = true

//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                self.dependency.router.isLoading = false
//                self.dependency.router.navigate(to: navigationViewModel)
            //            }

            experienceInteractor.performDeferredWork(workId: deferredLoadingWorkId) { [weak self] in
                self?.dependency.router.isLoading = false
                self?.dependency.router.navigate(to: navigationViewModel)
            }

//            let strongSelf = self
//            experienceInteractor.performDeferredWork(workId: deferredLoadingWorkId) {
////                guard let self = strongSelf  else { return }
//                strongSelf.dependency.router.isLoading = false
//                strongSelf.dependency.router.navigate(to: navigationViewModel)
//            }
        } else {
            dependency.router.navigate(to: navigationViewModel)
        }
    }
}
