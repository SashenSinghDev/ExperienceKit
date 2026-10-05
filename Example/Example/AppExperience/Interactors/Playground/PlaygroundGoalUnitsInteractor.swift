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
    private let selectionStateStore: SelectionStateStore

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?,
         selectionStateStore: SelectionStateStore) {
        self.experienceViewModel = experienceViewModel
        self.selectionStateStore = selectionStateStore
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        // Components only report changes, so seed the preselected options. A
        // value already in the store is an earlier choice and is kept.
        let selectedGoal = selectionStateStore.seedSelectedValue(Goal.fatLoss, for: SelectionKey.goal)
        let selectedUnits = selectionStateStore.seedSelectedValue(Units.metric, for: SelectionKey.units)

        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: [
                .spacerComponent(properties: .init(size: .small)),
                insetProgressStepper(currentStep: 1, totalSteps: 4),
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
                    value: Goal.fatLoss,
                    isSelected: selectedGoal == Goal.fatLoss
                ),
                .spacerComponent(properties: .init(size: .small)),
                goalCard(
                    title: "Maintenance",
                    subtitle: "Hold your weight and eat at maintenance every day.",
                    value: Goal.maintenance,
                    isSelected: selectedGoal == Goal.maintenance
                ),
                .spacerComponent(properties: .init(size: .small)),
                goalCard(
                    title: "Build mass",
                    subtitle: "A 10% surplus, the same every day.",
                    value: Goal.buildMass,
                    isSelected: selectedGoal == Goal.buildMass
                ),
                .spacerComponent(properties: .init(size: .large)),
                insetText(
                    title: "UNITS",
                    font: .caption2,
                    weight: .semibold,
                    foregroundStyle: .secondary
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetSegmentedControl(selectedUnits: selectedUnits)
            ],
            middleComponents: [],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Continue",
                        style: .glass,
                        navigation: .init(
                            navigationType: .push(Experience.playgroundBodyStats),
                            deferredLoadingWorkId: WorkID.continue,
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

    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void) {
        guard let deferredWork = DeferredWork(workId: workId, values: values) else {
            completion(nil)
            return
        }

        switch deferredWork {
        case .goalChanged(let goal):
            selectionStateStore.setSelectedValues([goal], for: SelectionKey.goal)
        case .unitsChanged(let units):
            selectionStateStore.setSelectedValues([units], for: SelectionKey.units)
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
                value: nil,
                isSelected: isSelected,
                badgeText: nil,
                selectionId: value,
                selectionGroupId: SelectionKey.goal,
                onChangeWorkId: WorkID.goalChanged,
                navigation: nil)
            ),
            horizontalSpacing: .medium)
        )
    }

    private func insetSegmentedControl(selectedUnits: String) -> Component {
        .containerComponent(properties: .init(
            component: .segmentedcontrolComponent(properties: .init(
                options: [
                    .init(label: "kg - cm", value: Units.metric),
                    .init(label: "lb - ft/in", value: Units.imperial)
                ],
                selectedValue: selectedUnits,
                accessibilityLabel: "Units",
                onChangeWorkId: WorkID.unitsChanged)
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
    /// The ids components send back. Any value travels separately, in `values`.
    enum WorkID: String, DeferredWorkID {
        case `continue`
        case goalChanged
        case unitsChanged
    }

    /// The work this screen performs. A change carries its new value.
    enum DeferredWork {
        case `continue`
        case goalChanged(String)
        case unitsChanged(String)

        init?(workId: any DeferredWorkID, values: [String]) {
            switch WorkID(rawValue: workId.rawValue) {
            case .continue:
                self = .continue
            case .goalChanged:
                guard let goal = values.first else { return nil }
                self = .goalChanged(goal)
            case .unitsChanged:
                guard let units = values.first else { return nil }
                self = .unitsChanged(units)
            case nil:
                return nil
            }
        }
    }

    /// Keys in the flow's selection state store.
    enum SelectionKey {
        static let goal = "playground-goal"
        static let units = "Units"
    }

    enum Goal {
        static let fatLoss = "fat-loss"
        static let maintenance = "maintenance"
        static let buildMass = "build-mass"
    }

    enum Units {
        static let metric = "metric"
        static let imperial = "imperial"
    }

    func selectedValue(for key: String) -> String {
        selectionStateStore.selectedValues(for: key).first ?? "nil"
    }
}
