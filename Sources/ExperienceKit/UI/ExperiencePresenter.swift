//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI
import Combine

public final class ExperiencePresenter: ObservableObject {
    public var delegate: (any ExperiencePresenterNotifier)?

    public enum State {
        case idle
        case loading
        case failed(Error)
        case loadedScrollable([AnyComponentViewModel])
        case loadedFullScreen(FullScreenViewModel)
    }

    @Published public var state: State = .idle

    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""

    let experienceViewModel: ExperienceViewModel?

    private let viewModelProvider: ViewModelProvider
    private let experienceInteractor: ExperienceInteractor
    private let dependency: ExperienceDependency
    public var vm: AnyComponentViewModel?

    public init(viewModelProvider: ViewModelProvider,
                experienceInteractor: ExperienceInteractor,
                dependency: ExperienceDependency) {
        self.viewModelProvider = viewModelProvider
        self.experienceInteractor = experienceInteractor
        self.experienceViewModel = experienceInteractor.experienceViewModel
        self.dependency = dependency

        dependency.experiencePresenterNotifier.delegate = self

        $searchText
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)  // Wait 300ms after user stops typing
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.filterResults(for: newValue)
            }
            .store(in: &cancellables)
    }

    deinit {
        let address = Unmanaged.passUnretained(self).toOpaque()
        print("deinit ExperiencePresenter at address \(address)")
    }

    private func filterResults(for query: String) {
        guard case .loadedScrollable(_) = state, experienceViewModel?.searchBar != nil else { return }

        experienceInteractor.performDeferredWork(workId: AnyDeferredWorkID(rawValue: query)) {  [weak self] experienceType in
            guard let self, let experienceType else { return }
            self.resolveState(for: experienceType)
        }
    }

    public func load() {
        self.experienceInteractor.load { [weak self] experienceType in

            guard let self else { return }
            self.resolveState(for: experienceType)
        }
    }

    private func resolveState(for experienceType: ExperienceType) {
        switch experienceType {
        case .fullScreen(let properties):
            let viewModel = FullScreenViewModel(properties: properties,
                                               dependency: dependency,
                                               id: UUID())
            self.state = .loadedFullScreen(viewModel)
        case .scrollable(let components):
            let viewModels: [AnyComponentViewModel] = components.compactMap {
                return self.viewModelProvider.viewModel(for: $0, dependency: self.dependency)
            }

            self.state = .loadedScrollable(viewModels)
        case .navigateImmediately(navigationViewModel: let navigationViewModel):
            navigate(with: navigationViewModel)
        }
    }

    private func navigate(with navigationViewModel: NavigationViewModel) {
        if let deferredLoadingWorkId = navigationViewModel.deferredLoadingWorkId {
            dependency.router.isLoading = true

            experienceInteractor.performDeferredWork(workId: deferredLoadingWorkId) { [weak self] _ in
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
