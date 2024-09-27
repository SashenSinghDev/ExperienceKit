//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public final class DefaultExperiencePresenter: ExperiencePresenter, ObservableObject {
    public typealias Dependancies = HasExperienceService

    public enum State {
         case idle
         case loading
         case failed(Error)
         case loaded([AnyComponentViewModel])
     }

    @Published private(set) var state = State.idle

    private let dependancies: Dependancies
    private let viewModelProvider: ViewModelProvider
    private let experienceService: ExperienceService
    private let experienceInteractor: ExperienceInteractor

    public init(dependancies: Dependancies,
                viewModelProvider: ViewModelProvider,
                experienceService: ExperienceService,
                experienceInteractor: ExperienceInteractor) {
        self.dependancies = dependancies
        self.viewModelProvider = viewModelProvider
        self.experienceService = experienceService
        self.experienceInteractor = experienceInteractor
    }

    var defaultComponent: [AnyComponentViewModel] {
        let components = [Component(contentType: "exampleComponent",
                                    properties: ExampleProperties(title: "mockTitle",
                                                                  profilePlaceholder: "Enter your bio",
                                                                  initialAmount: 1,
                                                                  navigationType: .deepdive),
                                    id: UUID())]

        let viewModels: [AnyComponentViewModel] = components.compactMap {
            return self.viewModelProvider.viewModel(for: $0)
        }

        return viewModels
    }


    public func load() {
        experienceInteractor.load { [weak self] components in

            guard let self else { return }

            let viewModels: [AnyComponentViewModel] = components.compactMap {
                return self.viewModelProvider.viewModel(for: $0)
            }

            self.state = .loaded(viewModels)
        }
    }
}
