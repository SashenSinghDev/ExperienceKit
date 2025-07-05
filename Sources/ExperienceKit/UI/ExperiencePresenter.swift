//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public final class ExperiencePresenter: ObservableObject {
    public var delegate: (any ExperiencePresenterNotifier)?

    public enum State {
        case idle
        case loading
        case failed(Error)
        case loadedScrollable([AnyComponentViewModel])
        case loadedScrollableWithNavigationBar([AnyComponentViewModel], navigationBarModel: NavigationBarModel)
        case loadedFullScreen(AnyComponentViewModel)
    }

    @Published public var state: State = .idle

    private let viewModelProvider: ViewModelProvider
    private let experienceInteractor: ExperienceInteractor
    private let dependency: ExperienceDependency
    public var vm: AnyComponentViewModel?

    public init(viewModelProvider: ViewModelProvider,
                experienceInteractor: ExperienceInteractor,
                dependency: ExperienceDependency) {
        self.viewModelProvider = viewModelProvider
        self.experienceInteractor = experienceInteractor
        self.dependency = dependency

        dependency.experiencePresenterNotifier.delegate = self

//        let address = Unmanaged.passUnretained(self).toOpaque()
//        print("make new presenter \(address)")
    }

    deinit {
        let address = Unmanaged.passUnretained(self).toOpaque()
        print("deinit ExperiencePresenter at address \(address)")
    }

    public func load() {

//        let address = Unmanaged.passUnretained(self).toOpaque()
//        print("load ExperiencePresenter at address \(address)")

        self.experienceInteractor.load { [weak self] experienceType in

            guard let self else { return }

            switch experienceType {
            case .fullScreen(let component):
                guard let viewModel = self.viewModelProvider.viewModel(for: component, dependency: dependency) else {
                    // TODO: Log this instead
                    fatalError("full screen component not supported")
                }
                self.state = .loadedFullScreen(viewModel)
                self.vm = viewModel
            case .scrollable(let components):
                let viewModels: [AnyComponentViewModel] = components.compactMap {
                    return self.viewModelProvider.viewModel(for: $0, dependency: self.dependency)
                }

                self.state = .loadedScrollable(viewModels)
            case .scrollableWithNavigationProperties(let components, let navigationBarModel):
                let viewModels: [AnyComponentViewModel] = components.compactMap {
                    return self.viewModelProvider.viewModel(for: $0, dependency: self.dependency)
                }

                self.state = .loadedScrollableWithNavigationBar(viewModels, navigationBarModel: navigationBarModel)
            case .navigateImmediately(navigationViewModel: let navigationViewModel):
                navigate(with: navigationViewModel)
            }
        }
    }

    private func navigate(with navigationViewModel: NavigationViewModel) {
        if let deferredLoadingWorkId = navigationViewModel.deferredLoadingWorkId {
            dependency.router.isLoading = true

            experienceInteractor.performDeferredWork(workId: deferredLoadingWorkId) { [weak self] in
                self?.dependency.router.isLoading = false
                self?.dependency.router.navigate(to: navigationViewModel)
            }
        } else {
            dependency.router.navigate(to: navigationViewModel)
        }
    }
}

extension ExperiencePresenter: ExperiencePresenterNotifierDelegate {
    public func navigate(navigationViewModel: NavigationViewModel) {
        navigate(with: navigationViewModel)
    }
}
