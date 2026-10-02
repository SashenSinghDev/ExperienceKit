//
//  PlaygroundWeeklySplitInteractor.swift
//  Example
//
//  Created by Claude on 02/10/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundWeeklySplitInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    private let experienceSelectionStateStore: ExperienceSelectionStateStore

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         experienceSelectionStateStore: ExperienceSelectionStateStore) {
        self.experienceViewModel = experienceViewModel
        self.experienceSelectionStateStore = experienceSelectionStateStore
    }

    /// Figma: 05 Weekly split.
    func load(completion: @escaping (ExperienceType) -> Void) {
        // Keep an earlier choice if the user has already been through this step.
        let selectedSplit = experienceSelectionStateStore.selectedValues(for: SelectionKey.weeklySplit).first
            .flatMap(WeeklySplit.init(rawValue:)) ?? .carbCycling

        var topComponents: [Component] = [
            .spacerComponent(properties: .init(size: .small)),
            insetProgressStepper(currentStep: 4, totalSteps: 4),
            .spacerComponent(properties: .init(size: .large)),
            insetText(
                title: "How do you want your week?",
                font: .title2,
                weight: .bold,
                foregroundStyle: .primary
            ),
            .spacerComponent(properties: .init(size: .small)),
            insetText(
                title: "Both lose the same amount over a week. The difference is whether some days get more food than others.",
                font: .footnote,
                weight: .regular,
                foregroundStyle: .secondary
            ),
            .spacerComponent(properties: .init(size: .medium))
        ]

        for (index, split) in WeeklySplit.allCases.enumerated() {
            if index > 0 {
                topComponents.append(.spacerComponent(properties: .init(size: .small)))
            }
            topComponents.append(weeklySplitCard(split, isSelected: split == selectedSplit))
        }

        topComponents += [
            .spacerComponent(properties: .init(size: .medium)),
            insetText(
                title: "You can switch in Me whenever you like.",
                font: .caption1,
                weight: .regular,
                foregroundStyle: .tertiary
            )
        ]

        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: topComponents,
            middleComponents: [],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "See my plan",
                        style: .primary,
                        navigation: .init(
                            navigationType: .dismiss,
                            deferredLoadingWorkId: DeferredWork.seeMyPlan,
                            experienceViewModel: nil))
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
        case .seeMyPlan:
            // The store is shared across the Playground flow, so values captured
            // on earlier screens are readable here too.
            print("Selected goal: \(selectedValue(for: SelectionKey.goal))")
            print("Selected units: \(selectedValue(for: SelectionKey.units))")
            print("Entered weight: \(selectedValue(for: SelectionKey.weight))")
            print("Entered height: \(selectedValue(for: SelectionKey.height))")
            print("Entered age: \(selectedValue(for: SelectionKey.age))")
            print("Selected sex: \(selectedValue(for: SelectionKey.sex))")
            print("Selected activity: \(selectedValue(for: SelectionKey.activity))")
            print("Selected weekly split: \(selectedValue(for: SelectionKey.weeklySplit))")
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

    private func weeklySplitCard(_ split: WeeklySplit, isSelected: Bool) -> Component {
        .containerComponent(properties: .init(
            component: .selectioncardComponent(properties: .init(
                title: split.title,
                subtitle: split.subtitle,
                value: nil,
                isSelected: isSelected,
                badgeText: split.badge,
                badgeStyle: .neutral,
                selectionId: split.rawValue,
                selectionGroupId: SelectionKey.weeklySplit,
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

private extension PlaygroundWeeklySplitInteractor {
    enum DeferredWork: String, DeferredWorkID {
        case seeMyPlan
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

        // Written on the activity screen.
        static let activity = "playground-activity"

        // Written on this screen.
        static let weeklySplit = "playground-weekly-split"
    }

    func selectedValue(for key: String) -> String {
        experienceSelectionStateStore.selectedValues(for: key).first ?? "nil"
    }
}

private extension PlaygroundWeeklySplitInteractor {
    /// The weekly split options, in the order they appear on screen.
    enum WeeklySplit: String, CaseIterable {
        case carbCycling = "carb-cycling"
        case sameEveryDay = "same-every-day"

        var title: String {
            switch self {
            case .carbCycling: return "Carb cycling"
            case .sameEveryDay: return "Same every day"
            }
        }

        var subtitle: String {
            switch self {
            case .carbCycling: return "Five lighter days and two at full maintenance. Put the high days on your hardest training."
            case .sameEveryDay: return "One target, seven days a week. Simpler to plan and cook for."
            }
        }

        var badge: String {
            switch self {
            case .carbCycling: return "5 low · 2 high"
            case .sameEveryDay: return "Flat"
            }
        }
    }
}
