//
//  GenericListItemViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 12/07/2025.
//

import Foundation
import SwiftUI

public final class GenericListItemViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperiencePresenterNotifier

    public let id: UUID
    let title: String
    let navigationViewModel: NavigationViewModel?
    private let experiencePresenterNotifier: ExperiencePresenterNotifier

    public init(properties: GenericListItemProperties,
                dependency: Dependencies,
         id: UUID) {
        self.id = id
        self.title = properties.title

        if let navigationProperties = properties.navigation as? NavigationProperties {
            self.navigationViewModel = .init(navigationType: navigationProperties.navigationType,
                                             deferredLoadingWorkId: navigationProperties.deferredLoadingWorkId,
                                             properties: navigationProperties.additionalProperties,
                                             navigationBarModel: navigationProperties.navigationBarModel)
        } else {
            navigationViewModel = nil
        }

        self.experiencePresenterNotifier = dependency.experiencePresenterNotifier
    }

    func navigate() {
        guard let navigationViewModel else {
            return
        }
        experiencePresenterNotifier.delegate?.navigate(navigationViewModel: navigationViewModel)
    }
}
