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
    /// Selection state shared by every screen in the Playground onboarding flow.
    ///
    /// ExperienceKit asks for a session each time SwiftUI re-evaluates the navigation
    /// stack, so the store must outlive individual `experienceSession(for:)` calls.
    /// It is owned here and cleared by `PlaygroundInteractor` when a new run of the
    /// flow starts, so each screen can capture values and a final screen can act on them.
    private let playgroundFlowSelectionStateStore = AppExperienceSelectionStateStore()

    /// Renders the animations ExperienceKit's `animation` component asks for.
    /// Stateless, so one instance serves every session that shows an animation.
    private let animationProvider = AppExperienceAnimationProvider()

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
        case .textFieldComponent:
            return .init(interactor: TextFieldComponentInteractor(experienceViewModel: experienceViewModel))
        case .selectionCardComponent:
            return .init(interactor: SelectionCardComponentInteractor(experienceViewModel: experienceViewModel))
        case .segmentedControlComponent:
            return .init(interactor: SegmentedControlComponentInteractor(experienceViewModel: experienceViewModel))
        case .imageComponent:
            return .init(interactor: ImageComponentInteractor(experienceViewModel: experienceViewModel))
        case .animationComponent:
            return .init(
                interactor: AnimationComponentInteractor(experienceViewModel: experienceViewModel),
                animationProvider: animationProvider
            )
        case .progressStepperComponent:
            return .init(interactor: ProgressStepperComponentInteractor(experienceViewModel: experienceViewModel))
        case .horizontalContainerComponent:
            return .init(interactor: HorizontalContainerComponentInteractor(experienceViewModel: experienceViewModel))
        case .playground:
            return .init(interactor: PlaygroundInteractor(
                experienceViewModel: experienceViewModel,
                playgroundFlowSelectionStateStore: playgroundFlowSelectionStateStore
            ))
        case .playgroundGoalUnits:
            return .init(
                interactor: PlaygroundGoalUnitsInteractor(
                    experienceViewModel: experienceViewModel,
                    experienceSelectionStateStore: playgroundFlowSelectionStateStore
                ),
                selectionStateStore: playgroundFlowSelectionStateStore
            )
        case .playgroundBodyStats:
            return .init(
                interactor: PlaygroundBodyStatsInteractor(
                    experienceViewModel: experienceViewModel,
                    experienceSelectionStateStore: playgroundFlowSelectionStateStore
                ),
                selectionStateStore: playgroundFlowSelectionStateStore
            )
        case .playgroundActivity:
            return .init(
                interactor: PlaygroundActivityInteractor(
                    experienceViewModel: experienceViewModel,
                    experienceSelectionStateStore: playgroundFlowSelectionStateStore
                ),
                selectionStateStore: playgroundFlowSelectionStateStore
            )
        case .playgroundWeeklySplit:
            return .init(
                interactor: PlaygroundWeeklySplitInteractor(
                    experienceViewModel: experienceViewModel,
                    experienceSelectionStateStore: playgroundFlowSelectionStateStore
                ),
                selectionStateStore: playgroundFlowSelectionStateStore
            )
        case .playgroundCalculating:
            return .init(
                interactor: PlaygroundCalculatingInteractor(
                    experienceViewModel: experienceViewModel,
                    experienceSelectionStateStore: playgroundFlowSelectionStateStore
                ),
                selectionStateStore: playgroundFlowSelectionStateStore,
                animationProvider: animationProvider
            )
        case .playgroundPlanReveal:
            return .init(interactor: PlaygroundPlanRevealInteractor(experienceViewModel: experienceViewModel))
        }
    }
}
