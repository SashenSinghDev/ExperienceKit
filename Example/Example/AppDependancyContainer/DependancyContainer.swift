//
//  DependancyContainer.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DependancyContainer {

    typealias Dependencies = HasEmptyDependancy

    // MARK: - Properties

    private let dependencies: Dependencies

    // MARK: - Public
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeFullScreenMainView(router: NavigationRouter) -> ExperienceView<ExperiencePresenter> {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers, dependency: ExperienceDependency(router: router))
        let experienceService = FullScreenExperienceService(router: router)
        let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
        let presenter = ExperiencePresenter(viewModelProvider: viewModelProvider,
                                            experienceInteractor: experienceInteractor)
        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
        return ExperienceView(presenter: presenter, viewProvider: viewProvider)
    }

    func makeScrollableMainView(router: NavigationRouter) -> ExperienceView<ExperiencePresenter> {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers, dependency: ExperienceDependency(router: router))
        let experienceService = DefaultExperienceService()
        let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
        let presenter = ExperiencePresenter(viewModelProvider: viewModelProvider,
                                            experienceInteractor: experienceInteractor)
        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
        return ExperienceView(presenter: presenter, viewProvider: viewProvider)
    }
}
