//
//  DependancyContainer.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit
import SwiftUI

final class AppExperienceProvider: ExperienceProvider {
    func experienceSession(for id: any ExperienceID, experienceViewModel: ExperienceViewModel?) -> ExperienceSession {
        guard let experience = Experience(rawValue: id.rawValue) else {
            fatalError("Experience id \(id.rawValue) not found")
        }

        switch experience {
        case .welcomeComponent:
            return .init(interactor: WelcomeComponentInteractor(experienceViewModel: experienceViewModel))
        case .scrollableScreen:
            return .init(interactor: ScrollableInteractor())
        case .experienceList: 
            return .init(interactor: ExperienceListInteractor(experienceViewModel: experienceViewModel))
        case .buttonComponent:
            return .init(interactor: ButtonComponentInteractor(experienceViewModel: experienceViewModel))
        case .fullScreen:
            return .init(interactor: FullScreenExperienceInteractor(experienceViewModel: experienceViewModel))
        case .navigationCapability:
            return .init(interactor: NavigationCapabilityInteractor(experienceViewModel: experienceViewModel))
        case .textComponent:
            return .init(interactor: TextComponentInteractor(experienceViewModel: experienceViewModel))
        case .selectionCardComponent:
            return .init(interactor: SelectionCardComponentInteractor(experienceViewModel: experienceViewModel))
        case .segmentedControlComponent:
            return .init(interactor: SegmentedControlComponentInteractor(experienceViewModel: experienceViewModel))
        case .imageComponent:
            return .init(interactor: ImageComponentInteractor(experienceViewModel: experienceViewModel))
        case .progressStepperComponent:
            return .init(interactor: ProgressStepperComponentInteractor(experienceViewModel: experienceViewModel))
        case .playground:
            return .init(interactor: PlaygroundInteractor(experienceViewModel: experienceViewModel))
        case .playgroundGoalUnits:
            let selectionStateStore = AppExperienceSelectionStateStore()
            return .init(
                interactor: PlaygroundGoalUnitsInteractor(
                    experienceViewModel: experienceViewModel,
                    experienceSelectionStateStore: selectionStateStore
                ),
                selectionStateStore: selectionStateStore
            )
        }
    }
}
