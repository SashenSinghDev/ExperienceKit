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

    lazy var viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
    lazy var viewProvider = ViewProvider(supportedComponentRegisters: registers)

    public init(registers: [ComponentRegister],
                experienceProvider: ExperienceProvider) {
        self.registers = registers
        self.experienceProvider = experienceProvider
    }

    func experienceView(for id: String, router: DefaultExperienceRouter, properties: [String: String]?, viewModelID: UUID, experienceID: String) -> ExperienceView<ExperiencePresenter> {
        let experienceInteractor = experienceProvider.returnExperienceInteractor(for: id, properties: properties)
        let experienceDependency = ExperienceDependency(router: router,
                                                        experiencePresenterNotifier: DefaultExperiencePresenterNotifier(),
                                                        viewProvider: viewProvider,
                                                        viewModelProvider: viewModelProvider)

        let experiencePresenter: ExperiencePresenter = {
            guard let presenter: ExperiencePresenter = router.presenter(for: viewModelID) else {
                let presenterToReturn = ExperiencePresenter(viewModelProvider: viewModelProvider,
                                                            experienceInteractor: experienceInteractor,
                                                            dependency: experienceDependency)

                let address = Unmanaged.passUnretained(presenterToReturn).toOpaque()
                print("Create new presenter  \(experienceID) \(address) \(viewModelID)===========")

                router.storePresenter(presenterToReturn, for: viewModelID)
                return presenterToReturn
            }
            return presenter
        }()

        let experienceView = ExperienceView(presenter: experiencePresenter, viewProvider: viewProvider, router: router)

        return experienceView
    }
}
