//
//  WelcomeViewModel.swift
//  
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation
import SwiftUI

public final class WelcomeViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency & HasRouter & HasExperiencePresenterNotifier

    public let id: UUID
    let image: ExperienceImage
    let description: DescriptionViewModel
    let primaryButton: ButtonViewModel
    var secondaryButton: ButtonViewModel?

    public init(properties: WelcomeProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.image = properties.image
        self.description = .init(properties: properties.description,
                                 dependency: dependency,
                                 id: id)
        self.primaryButton = .init(properties: properties.primaryButton,
                                   dependency: dependency,
                                   id: id)

        if let secondaryButtonProperties = properties.secondaryButton {
            self.secondaryButton = .init(properties: secondaryButtonProperties,
                                         dependency: dependency,
                                         id: id)
        }
    }
}
