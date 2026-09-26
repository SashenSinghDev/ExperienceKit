//
//  PlaygroundGoalUnitsInteractor.swift
//  Example
//
//  Created by Codex on 26/09/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundGoalUnitsInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    private let experienceSelectionStateStore: ExperienceSelectionStateStore

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         experienceSelectionStateStore: ExperienceSelectionStateStore) {
        self.experienceViewModel = experienceViewModel
        self.experienceSelectionStateStore = experienceSelectionStateStore
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: [
                .spacerComponent(properties: .init(size: .small)),
                insetProgressStepper(currentStep: 1, totalSteps: 3),
                .spacerComponent(properties: .init(size: .large)),
                insetText(
                    title: "What are we aiming at?",
                    font: .title2,
                    weight: .bold,
                    foregroundStyle: .primary
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetText(
                    title: "You can change this later without losing your history.",
                    font: .footnote,
                    weight: .regular,
                    foregroundStyle: .secondary
                ),
                .spacerComponent(properties: .init(size: .large)),
                goalCard(
                    title: "Fat loss",
                    subtitle: "A steady weekly deficit. Next you choose carb cycling or the same every day.",
                    value: "fat-loss",
                    isSelected: true
                ),
                .spacerComponent(properties: .init(size: .small)),
                goalCard(
                    title: "Maintenance",
                    subtitle: "Hold your weight and eat at maintenance every day.",
                    value: "maintenance",
                    isSelected: false
                ),
                .spacerComponent(properties: .init(size: .small)),
                goalCard(
                    title: "Build mass",
                    subtitle: "A 10% surplus, the same every day.",
                    value: "build-mass",
                    isSelected: false
                ),
                .spacerComponent(properties: .init(size: .large)),
                insetText(
                    title: "UNITS",
                    font: .caption2,
                    weight: .semibold,
                    foregroundStyle: .secondary
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetSegmentedControl()
            ],
            middleComponents: [],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Continue",
                        style: .primary,
                        navigation: .init(
                            navigationType: .dismiss,
                            deferredLoadingWorkId: DeferredWork.continue,
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
        case .continue:
            print("Selected goal: \(selectedValue(for: SelectionKey.goal))")
            print("Selected units: \(selectedValue(for: SelectionKey.units))")
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

    private func goalCard(title: String,
                          subtitle: String,
                          value: String,
                          isSelected: Bool) -> Component {
        .containerComponent(properties: .init(
            component: .selectioncardComponent(properties: .init(
                title: title,
                subtitle: subtitle,
                value: "",
                isSelected: isSelected,
                badgeText: nil,
                selectionId: value,
                selectionGroupId: "playground-goal",
                navigation: nil)
            ),
            horizontalSpacing: .medium)
        )
    }

    private func insetSegmentedControl() -> Component {
        .containerComponent(properties: .init(
            component: .segmentedcontrolComponent(properties: .init(
                options: [
                    .init(label: "kg - cm", value: "metric"),
                    .init(label: "lb - ft/in", value: "imperial")
                ],
                selectedValue: "metric",
                accessibilityLabel: "Units")
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

private extension PlaygroundGoalUnitsInteractor {
    enum DeferredWork: String, DeferredWorkID {
        case `continue`
    }

    enum SelectionKey {
        static let goal = "playground-goal"
        static let units = "Units"
    }

    func selectedValue(for key: String) -> String {
        experienceSelectionStateStore.selectedValues(for: key).first ?? "nil"
    }
}
