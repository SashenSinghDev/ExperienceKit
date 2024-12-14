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

    func makeFullScreenMainView() -> ExperienceView<ExperiencePresenter> {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
        let experienceService = FullScreenExperienceService()
        let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
        let viewModel = ExperienceViewModel(experienceCharacterType: .fullScreen)
        let presenter = ExperiencePresenter(viewModelProvider: viewModelProvider,
                                            experienceInteractor: experienceInteractor,
                                            viewModel: viewModel)
        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
        return ExperienceView(presenter: presenter, viewProvider: viewProvider)
    }

    func makeScrollableMainView() -> ExperienceView<ExperiencePresenter> {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
        let experienceService = DefaultExperienceService()
        let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
        let viewModel = ExperienceViewModel(experienceCharacterType: .scrollable)
        let presenter = ExperiencePresenter(viewModelProvider: viewModelProvider,
                                            experienceInteractor: experienceInteractor,
                                            viewModel: viewModel)
        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
        return ExperienceView(presenter: presenter, viewProvider: viewProvider)
    }
}
