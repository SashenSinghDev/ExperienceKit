//
//  PlaygroundBodyStatsInteractor.swift
//  Example
//
//  Created by Claude on 27/09/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundBodyStatsInteractor: ExperienceInteractor {
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
                insetProgressStepper(currentStep: 2, totalSteps: 3),
                .spacerComponent(properties: .init(size: .large)),
                insetText(
                    title: "A little about your body",
                    font: .title2,
                    weight: .bold,
                    foregroundStyle: .primary
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetText(
                    title: "These are the numbers the calorie maths needs. Nothing here is shared.",
                    font: .footnote,
                    weight: .regular,
                    foregroundStyle: .secondary
                ),
                .spacerComponent(properties: .init(size: .large)),
                insetMeasurementsRow(),
                .spacerComponent(properties: .init(size: .large)),
                insetText(
                    title: "Sex",
                    font: .footnote,
                    weight: .regular,
                    foregroundStyle: .secondary
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetSexSegmentedControl(),
                .spacerComponent(properties: .init(size: .small)),
                insetText(
                    title: "We only use this to pick the right calorie formula. Choose “Rather not say” and we’ll use an average.",
                    font: .footnote,
                    weight: .regular,
                    foregroundStyle: .secondary
                )
            ],
            middleComponents: [],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Continue",
                        style: .glass,
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
            // The store is shared across the Playground flow, so values captured
            // on earlier screens (goal, units) are readable here too.
            print("Selected goal: \(selectedValue(for: SelectionKey.goal))")
            print("Selected units: \(selectedValue(for: SelectionKey.units))")
            print("Entered weight: \(selectedValue(for: SelectionKey.weight))")
            print("Entered height: \(selectedValue(for: SelectionKey.height))")
            print("Entered age: \(selectedValue(for: SelectionKey.age))")
            print("Selected sex: \(selectedValue(for: SelectionKey.sex))")
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

    /// Weight, height and age side by side, each taking an equal share of the width.
    private func insetMeasurementsRow() -> Component {
        .containerComponent(properties: .init(
            component: .horizontalcontainerComponent(properties: .init(
                components: [
                    measurementField(
                        label: "Weight",
                        placeholder: "88",
                        unit: "kg",
                        keyboardType: .decimalPad,
                        selectionKey: SelectionKey.weight
                    ),
                    measurementField(
                        label: "Height",
                        placeholder: "180",
                        unit: "cm",
                        keyboardType: .numberPad,
                        selectionKey: SelectionKey.height
                    ),
                    measurementField(
                        label: "Age",
                        placeholder: "32",
                        unit: "yrs",
                        keyboardType: .numberPad,
                        selectionKey: SelectionKey.age
                    )
                ],
                spacing: .small,
                alignment: .top,
                distribution: .fillEqually)
            ),
            horizontalSpacing: .medium)
        )
    }

    private func measurementField(label: String,
                                  placeholder: String,
                                  unit: String,
                                  keyboardType: TextFieldProperties.KeyboardType,
                                  selectionKey: String) -> Component {
        .textfieldComponent(properties: .init(
            keyboardType: keyboardType,
            label: label,
            placeholder: placeholder,
            showsClearButton: false,
            unit: unit,
            selectionKey: selectionKey)
        )
    }

    private func insetSexSegmentedControl() -> Component {
        .containerComponent(properties: .init(
            component: .segmentedcontrolComponent(properties: .init(
                options: [
                    .init(label: "Male", value: "male"),
                    .init(label: "Female", value: "female"),
                    .init(label: "Rather not say", value: "rather-not-say")
                ],
                selectedValue: "male",
                accessibilityLabel: SelectionKey.sex)
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

private extension PlaygroundBodyStatsInteractor {
    enum DeferredWork: String, DeferredWorkID {
        case `continue`
    }

    enum SelectionKey {
        // Written on the goal & units screen.
        static let goal = "playground-goal"
        static let units = "Units"

        // Written on this screen.
        static let weight = "playground-weight"
        static let height = "playground-height"
        static let age = "playground-age"
        static let sex = "Sex"
    }

    func selectedValue(for key: String) -> String {
        experienceSelectionStateStore.selectedValues(for: key).first ?? "nil"
    }
}
