//
//  PlaygroundActivityInteractor.swift
//  Example
//
//  Created by Claude on 02/10/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundActivityInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    private let experienceSelectionStateStore: ExperienceSelectionStateStore

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         experienceSelectionStateStore: ExperienceSelectionStateStore) {
        self.experienceViewModel = experienceViewModel
        self.experienceSelectionStateStore = experienceSelectionStateStore
    }

    /// Figma: 04 Activity.
    func load(completion: @escaping (ExperienceType) -> Void) {
        // Keep an earlier choice if the user has already been through this step.
        let selectedLevel = experienceSelectionStateStore.selectedValues(for: SelectionKey.activity).first
            .flatMap(ActivityLevel.init(rawValue:)) ?? .moderatelyActive

        var topComponents: [Component] = [
            .spacerComponent(properties: .init(size: .small)),
            insetProgressStepper(currentStep: 3, totalSteps: 3),
            .spacerComponent(properties: .init(size: .large)),
            insetText(
                title: "How much do you move?",
                font: .title1,
                weight: .bold,
                foregroundStyle: .primary
            ),
            .spacerComponent(properties: .init(size: .small)),
            insetText(
                title: "Count your job as well as the gym. Most people training four or five days a week land on Moderately Active.",
                font: .subheadline,
                weight: .regular,
                foregroundStyle: .secondary
            ),
            .spacerComponent(properties: .init(size: .large))
        ]

        for (index, level) in ActivityLevel.allCases.enumerated() {
            if index > 0 {
                topComponents.append(.spacerComponent(properties: .init(size: .small)))
            }
            topComponents.append(activityCard(level, isSelected: level == selectedLevel))
        }

        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: topComponents,
            middleComponents: [],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Continue",
                        style: .primary,
                        navigation: .init(
                            navigationType: .push(Experience.playgroundWeeklySplit),
                            deferredLoadingWorkId: DeferredWork.continue,
                            experienceViewModel: .init(
                                searchBar: nil,
                                navigationBar: nil)))
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .small))
            ]
        )))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        guard let deferredWork = DeferredWork(rawValue: workId.rawValue) else {
            completion(nil)
            return
        }

        switch deferredWork {
        case .continue:
            // The store is shared across the Playground flow, so values captured
            // on earlier screens are readable here too.
            print("Selected goal: \(selectedValue(for: SelectionKey.goal))")
            print("Selected units: \(selectedValue(for: SelectionKey.units))")
            print("Entered weight: \(selectedValue(for: SelectionKey.weight))")
            print("Entered height: \(selectedValue(for: SelectionKey.height))")
            print("Entered age: \(selectedValue(for: SelectionKey.age))")
            print("Selected sex: \(selectedValue(for: SelectionKey.sex))")
            print("Selected activity: \(selectedValue(for: SelectionKey.activity))")
        }

        completion(nil)
    }

    private func insetText(title: String,
                           font: TextProperties.Font,
                           weight: TextProperties.Weight,
                           foregroundStyle: TextProperties.ForegroundStyle) -> Component {
        .containerComponent(properties: .init(
            component: .textComponent(properties: .init(
                title: title,
                font: font,
                weight: weight,
                alignment: .leading,
                foregroundStyle: foregroundStyle)
            ),
            horizontalSpacing: .medium,
            alignment: .leading)
        )
    }

    private func activityCard(_ level: ActivityLevel, isSelected: Bool) -> Component {
        .containerComponent(properties: .init(
            component: .selectioncardComponent(properties: .init(
                title: level.title,
                subtitle: level.subtitle,
                value: nil,
                isSelected: isSelected,
                badgeText: nil,
                selectionId: level.rawValue,
                selectionGroupId: SelectionKey.activity,
                navigation: nil)
            ),
            horizontalSpacing: .medium)
        )
    }

    private func insetProgressStepper(currentStep: Int, totalSteps: Int) -> Component {
        .containerComponent(properties: .init(
            component: .progressstepperComponent(properties: .init(
                currentStep: currentStep,
                totalSteps: totalSteps)
            ),
            horizontalSpacing: .medium)
        )
    }
}

private extension PlaygroundActivityInteractor {
    enum DeferredWork: String, DeferredWorkID {
        case `continue`
    }

    enum SelectionKey {
        // Written on the goal & units screen.
        static let goal = "playground-goal"
        static let units = "Units"

        // Written on the body stats screen.
        static let weight = "playground-weight"
        static let height = "playground-height"
        static let age = "playground-age"
        static let sex = "Sex"

        // Written on this screen.
        static let activity = "playground-activity"
    }

    func selectedValue(for key: String) -> String {
        experienceSelectionStateStore.selectedValues(for: key).first ?? "nil"
    }
}

private extension PlaygroundActivityInteractor {
    /// The activity levels, in the order they appear on screen.
    enum ActivityLevel: String, CaseIterable {
        case sedentary
        case lightlyActive = "lightly-active"
        case moderatelyActive = "moderately-active"
        case veryActive = "very-active"
        case extremelyActive = "extremely-active"

        var title: String {
            switch self {
            case .sedentary: return "Sedentary"
            case .lightlyActive: return "Lightly active"
            case .moderatelyActive: return "Moderately active"
            case .veryActive: return "Very active"
            case .extremelyActive: return "Extremely active"
            }
        }

        var subtitle: String {
            switch self {
            case .sedentary: return "Desk job, little or no structured exercise"
            case .lightlyActive: return "Light daily activity plus exercise 1–3 days a week"
            case .moderatelyActive: return "Moderate activity plus hard training 4–5 days a week"
            case .veryActive: return "Demanding lifestyle plus rigorous exercise 6–7 days"
            case .extremelyActive: return "Endurance athlete, or a very physical job on top"
            }
        }
    }
}
