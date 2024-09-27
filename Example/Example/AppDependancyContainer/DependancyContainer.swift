//
//  DependancyContainer.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DependancyContainer {

    typealias Dependencies = HasExperienceService

    // MARK: - Properties

    private let dependencies: Dependencies

    // MARK: - Public

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeMainView() -> ExperienceView {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(registers: registers)
        let experienceService = ExampleComponentProviderService()
        let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
        let presenter = DefaultExperiencePresenter(dependancies: dependencies,
                                                   viewModelProvider: viewModelProvider,
                                                   experienceService: experienceService, 
                                                   experienceInteractor: experienceInteractor)
        let viewProvider = ViewProvider(registers: registers)
        return ExperienceView(presenter: presenter, viewProvider: viewProvider)
    }
}
