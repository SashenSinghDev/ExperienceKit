//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public final class DefaultExperiencePresenter: ExperiencePresenter {
    public typealias Dependancies = HasExperienceService
//    public typealias ExperienceDependency = HasRouter

    private let dependancies: Dependancies
    private let viewModelProvider: ViewModelProvider
    private let experienceService: ExperienceService
    private var storedViewModels = [AnyComponentViewModel]()
    private let experienceInteractor: ExperienceInteractor

    public weak var scene: ExperienceScene?

    public init(dependancies: Dependancies,
                viewModelProvider: ViewModelProvider,
                experienceService: ExperienceService,
                experienceInteractor: ExperienceInteractor) {
        self.dependancies = dependancies
        self.viewModelProvider = viewModelProvider
        self.experienceService = experienceService
        self.experienceInteractor = experienceInteractor
    }

    public func performAction(_ action: Experience.Action) {
        switch action {
        case .load:
            experienceInteractor.load { [weak self] components in

                guard let self else { return }

                let viewModels: [AnyComponentViewModel] = components.compactMap {
                    return self.viewModelProvider.viewModel(for: $0)
                }

//                viewModel = viewModel.value as? (any ComponentViewModel)

                storedViewModels = viewModels

                self.scene?.performUpdate(.setAnyViewModel(.init(components: viewModels)))
            }
        }
    }

    public func navigate(_ id: UUID) -> AnyView {
        guard let viewModel = storedViewModels.first(where: { $0.id == id }) else { return AnyView(EmptyView()) }
        return experienceInteractor.navigate(for: viewModel)
//        return experienceInteractor.navigate(for: id)
    }
}
