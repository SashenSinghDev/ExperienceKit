//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

public final class DefaultExperiencePresenter: ExperiencePresenter {
    public typealias Dependancies = HasComponentProviderService

    private let dependancies: Dependancies
    private let viewModelProvider: ViewModelProvider

    public weak var scene: ExperienceScene?

    public init(dependancies: Dependancies,
         viewModelProvider: ViewModelProvider) {
        self.dependancies = dependancies
        self.viewModelProvider = viewModelProvider
    }

    public func performAction(_ action: Experience.Action) {
        switch action {
        case .load:
            dependancies.componentProviderService.load { [weak self] components in

                guard let self else { return }

                let viewModels: [AnyComponentViewModel] = components.compactMap {
                    return self.viewModelProvider.viewModel(for: $0)
                }

                self.scene?.performUpdate(.setAnyViewModel(.init(components: viewModels)))
            }
        }
    }
}
