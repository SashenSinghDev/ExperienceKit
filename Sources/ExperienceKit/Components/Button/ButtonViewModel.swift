//
//  ButtonViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 16/02/2025.
//

import Foundation
import SwiftUI

public final class ButtonViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasRouter

    public let id: UUID
    public let title: String
    public let navigationViewModel: NavigationViewModel
    let style: ButtonProperties.Style
    let router: any ExperienceRouter

    public init(properties: ButtonProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.style = properties.style
        self.navigationViewModel = .init(navigationType: properties.navigation.navigationType,
                                         deferredLoadingWorkId: properties.navigation.deferredLoadingWorkId)
        self.router = dependency.router
    }

    func navigate() {
        router.delegate?.navigate(to: navigationViewModel)
    }
}
