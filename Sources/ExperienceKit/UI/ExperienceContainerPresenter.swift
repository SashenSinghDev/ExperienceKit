//
//  ExperienceContainerPresenter.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 10/06/2025.
//

import Foundation

public final class ExperienceContainerPresenter {

    private let registers: [ComponentRegister]
    private let experienceProvider: ExperienceProvider

    public init(registers: [ComponentRegister],
                experienceProvider: ExperienceProvider) {
        self.registers = registers
        self.experienceProvider = experienceProvider
    }

    func experienceView(for id: String, router: DefaultExperienceRouter, viewModelID: UUID) -> ExperienceView<ExperiencePresenter> {
        let experienceInteractor = experienceProvider.returnExperienceInteractor(for: id)
        let experienceDependency = ExperienceDependency(router: router, experiencePresenterNotifier: DefaultExperiencePresenterNotifier())
        let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
        let viewProvider = ViewProvider(supportedComponentRegisters: registers)

        let experiencePresenter: ExperiencePresenter = {
            guard let presenter: ExperiencePresenter = router.presenter(for: viewModelID) else {
                print("===========")
                let presenterToReturn = ExperiencePresenter(viewModelProvider: viewModelProvider,
                                                            experienceInteractor: experienceInteractor,
                                                            dependency: experienceDependency)
                router.storePresenter(presenterToReturn, for: viewModelID)
                return presenterToReturn
            }
            return presenter
        }()

        return ExperienceView(presenter: experiencePresenter, viewProvider: viewProvider, router: router)
    }
}
