//
//  DependancyContainer.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit
import SwiftUI

//final class DependancyContainer: ExperienceDependancyContainer {
//    
//    typealias Dependencies = HasEmptyDependancy
//
//    // MARK: - Properties
//
//    private let dependencies: Dependencies
//    private let registers: [ComponentRegister] = allRegisters
//
//    // MARK: - Public
//    
//    init(dependencies: Dependencies) {
//        self.dependencies = dependencies
//    }
//
////    func returnDependenciesForExperience(with id: String) -> (ExperienceService, ExperienceInteractor) {
////
////    }
//
//    func makeFullScreenMainView(router: NavigationRouter, existingPresenter: ExperiencePresenter?, viewModelID: UUID) -> ExperienceView<ExperiencePresenter> {
//
//        let presenter: ExperiencePresenter
//        if let existingPresenter = existingPresenter {
//            presenter = existingPresenter
//        } else {
//            print("===========")
//            print("make new presenter \(viewModelID)")
//            let experienceDependency = ExperienceDependency(router: router, experiencePresenterNotifier: DefaultExperiencePresenterNotifier())
//            let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
//            let experienceService = FullScreenExperienceService()
//            let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
//            presenter = ExperiencePresenter(viewModelProvider: viewModelProvider,
//                                            experienceInteractor: experienceInteractor,
//                                            dependency: experienceDependency)
//            router.storePresenter(presenter, for: viewModelID)
//        }
//
//        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
//        return ExperienceView(presenter: presenter, viewProvider: viewProvider, router: router)
//    }
//
//    func makeScrollableMainView(router: NavigationRouter, existingPresenter: ExperiencePresenter?, viewModelID: UUID) -> ExperienceView<ExperiencePresenter> {
//        let presenter: ExperiencePresenter
//        if let existingPresenter = existingPresenter {
//            presenter = existingPresenter
//        } else {
//            let experienceDependency = ExperienceDependency(router: router, experiencePresenterNotifier: DefaultExperiencePresenterNotifier())
//            let viewModelProvider = DefaultViewModelProvider(supportedComponentRegisters: registers)
//            let experienceService = DefaultExperienceService()
//            let experienceInteractor = ExampleExperienceInteractor(experienceService: experienceService)
//            presenter = ExperiencePresenter(viewModelProvider: viewModelProvider,
//                                            experienceInteractor: experienceInteractor,
//                                            dependency: experienceDependency)
//            router.storePresenter(presenter, for: viewModelID)
//        }
//
//        let viewProvider = ViewProvider(supportedComponentRegisters: registers)
//        return ExperienceView(presenter: presenter, viewProvider: viewProvider, router: router)
//    }
//
//    func experienceView(for id: String, router: NavigationRouter, viewModelID: UUID) -> ExperienceView<ExperiencePresenter> {
//        let cachedExperiencePresenter: ExperiencePresenter? = {
//            guard let presenter: ExperiencePresenter = router.presenter(for: viewModelID) else {
//                return nil
//            }
//            return presenter
//        }()
//
//        switch id {
//        case "fullScreen":
//            return makeFullScreenMainView(router: router, existingPresenter: cachedExperiencePresenter, viewModelID: viewModelID)
//        case "scrollableScreeen":
//            return makeScrollableMainView(router: router, existingPresenter: cachedExperiencePresenter, viewModelID: viewModelID)
//        default:
//            fatalError()
//        }
//    }
//}

final class AppExperienceProvider: ExperienceProvider {
    func returnExperienceDependancies(for id: String) -> (ExperienceService, ExperienceInteractor) {
        switch id {
        case "fullScreen":
            let experienceService = FullScreenExperienceService()
            return (experienceService, ExampleExperienceInteractor(experienceService: experienceService))
        case "scrollableScreeen":
            let experienceService = DefaultExperienceService()
            return (experienceService, ExampleExperienceInteractor(experienceService: experienceService))
        default:
            fatalError("experienceId \(id) not found")
        }
    }
}
