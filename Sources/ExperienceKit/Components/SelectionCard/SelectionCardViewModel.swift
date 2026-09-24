//
//  SelectionCardViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation
import SwiftUI

public final class SelectionCardViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperiencePresenterNotifier

    public let id: UUID
    let title: String
    let subtitle: String
    let isSelected: Bool
    let showBadge: Bool
    let navigationViewModel: NavigationViewModel?
    private let experiencePresenterNotifier: ExperiencePresenterNotifier

    public init(properties: SelectionCardProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.subtitle = properties.subtitle
        self.isSelected = properties.isSelected
        self.showBadge = properties.showBadge

        if let navigationProperties = properties.navigation {
            self.navigationViewModel = .init(navigationType: navigationProperties.navigationType,
                                             deferredLoadingWorkId: navigationProperties.deferredLoadingWorkId,
                                             experienceViewModel: navigationProperties.experienceViewModel)
        } else {
            self.navigationViewModel = nil
        }

        self.experiencePresenterNotifier = dependency.experiencePresenterNotifier
    }

    // Tapping the card only notifies the parent (via navigation) that this option
    // was selected. Radio-group exclusivity and updating `isSelected` for every
    // card in the group is server/parent-driven, same pattern as GenericListItem.
    func select() {
        guard let navigationViewModel else {
            return
        }
        experiencePresenterNotifier.delegate?.navigate(navigationViewModel: navigationViewModel)
    }
}
