//
//  ButtonViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 16/02/2025.
//

import Foundation
import SwiftUI

public struct ButtonViewModel: ComponentViewModel {
    public typealias Dependencies = HasRouter & HasExperiencePresenterNotifier

    public let id: UUID
    public let title: String
    public let isFullWidth: Bool
    let style: ButtonProperties.Style
    private let router: any ExperienceRouter
    private let navigationViewModel: NavigationViewModel
    private let experiencePresenterNotifier: ExperiencePresenterNotifier

    public init(properties: ButtonProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.style = properties.style
        self.isFullWidth = properties.isFullWidth
        self.navigationViewModel = .init(navigationType: properties.navigation.navigationType,
                                         deferredLoadingWorkId: properties.navigation.deferredLoadingWorkId,
                                         properties: properties.navigation.additionalProperties)
        self.router = dependency.router
        self.experiencePresenterNotifier = dependency.experiencePresenterNotifier
    }

    func navigate() {
//        if let deferredLoadingWorkId = navigationViewModel.deferredLoadingWorkId {
//            experiencePresenterNotifier.delegate?.performDeferredWork(workId: deferredLoadingWorkId, completion: {
//                self.router.navigate(to: self.navigationViewModel)
//            })
//        } else {
//            router.navigate(to: navigationViewModel)
//        }
        experiencePresenterNotifier.delegate?.navigate(navigationViewModel: navigationViewModel)
    }
}
