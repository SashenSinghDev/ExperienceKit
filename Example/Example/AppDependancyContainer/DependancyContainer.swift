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

    func makeMainView() -> ExperienceView<DefaultExperiencePresenter> {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
        let experienceService = ExampleComponentProviderService()
        let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
        let presenter = DefaultExperiencePresenter(viewModelProvider: viewModelProvider,
                                                   experienceInteractor: experienceInteractor)
        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
        return ExperienceView(presenter: presenter, viewProvider: viewProvider)
    }
}
