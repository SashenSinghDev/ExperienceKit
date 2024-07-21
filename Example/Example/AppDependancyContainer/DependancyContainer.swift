//
//  DependancyContainer.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DependancyContainer {

    typealias Dependencies = HasComponentProviderService

    // MARK: - Properties

    private let dependencies: Dependencies

    // MARK: - Public

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeMainView() -> ExperienceView {
        let registers: [ComponentRegister] = allRegisters
        let viewModelProvider = DefaultViewModelProvider(registers: registers)
        let presenter = DefaultExperiencePresenter(dependancies: dependencies, viewModelProvider: viewModelProvider)
        let observable = ExperienceObservable(presenter: presenter)
        let viewProvider = ViewProvider(registers: registers)
        presenter.scene = observable
        return ExperienceView(observer: observable, viewProvider: viewProvider)
    }
}
