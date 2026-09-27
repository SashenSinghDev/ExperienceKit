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
        completion(bodyStatsExperience(missingMeasurements: []))
    }

    /// Builds the screen. When `missingMeasurements` is non-empty, those fields render
    /// in the error state, the first one takes focus, and a single message below the
    /// row lists what is still needed (Figma: 03 Body stats · Error · Missing fields).
    private func bodyStatsExperience(missingMeasurements: [BodyMeasurement]) -> ExperienceType {
        var topComponents: [Component] = [
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
            insetMeasurementsRow(missingMeasurements: missingMeasurements)
        ]
        topComponents += measurementsError(for: missingMeasurements)
        topComponents += [
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
        ]

        return .fullScreen(properties: .init(
            image: nil,
            topComponents: topComponents,
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
        ))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        guard let deferredWork = DeferredWork(rawValue: workId.rawValue) else {
            completion(nil)
            return
        }

        switch deferredWork {
        case .continue:
            let missingMeasurements = BodyMeasurement.allCases.filter { !hasEnteredValue(for: $0) }

            // Returning an experience keeps the user on this screen, re-rendered
            // with the missing fields in their error state, instead of navigating.
            guard missingMeasurements.isEmpty else {
                completion(bodyStatsExperience(missingMeasurements: missingMeasurements))
                return
            }

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
    private func insetMeasurementsRow(missingMeasurements: [BodyMeasurement]) -> Component {
        .containerComponent(properties: .init(
            component: .horizontalcontainerComponent(properties: .init(
                components: BodyMeasurement.allCases.map {
                    measurementField(
                        $0,
                        isMissing: missingMeasurements.contains($0),
                        requestsFocus: $0 == missingMeasurements.first
                    )
                },
                spacing: .small,
                alignment: .top,
                distribution: .fillEqually)
            ),
            horizontalSpacing: .medium)
        )
    }

    private func measurementField(_ measurement: BodyMeasurement,
                                  isMissing: Bool,
                                  requestsFocus: Bool) -> Component {
        // Carry entered values across a re-render so a failed Continue keeps them.
        let enteredValue = experienceSelectionStateStore.selectedValues(for: measurement.selectionKey).first ?? ""
        let state: TextFieldProperties.State = isMissing ? .error : (enteredValue.isEmpty ? .empty : .filled)

        return .textfieldComponent(properties: .init(
            state: state,
            keyboardType: measurement.keyboardType,
            label: measurement.label,
            placeholder: measurement.placeholder,
            value: enteredValue,
            showsClearButton: false,
            unit: measurement.unit,
            selectionKey: measurement.selectionKey,
            requestsFocus: requestsFocus)
        )
    }

    /// One shared message under the measurements row rather than one per field. It
    /// updates as the user types, dropping each field once it has a value.
    private func measurementsError(for missingMeasurements: [BodyMeasurement]) -> [Component] {
        guard !missingMeasurements.isEmpty else {
            return []
        }

        return [
            .spacerComponent(properties: .init(size: .small)),
            .containerComponent(properties: .init(
                component: .textComponent(properties: .init(
                    title: "Add your {fields} to continue.",
                    font: .footnote,
                    weight: .regular,
                    alignment: .leading,
                    foregroundStyle: .error,
                    missingSelections: .init(fields: missingMeasurements.map {
                        .init(name: $0.label.lowercased(), selectionKey: $0.selectionKey)
                    }))
                ),
                horizontalSpacing: .medium,
                alignment: .leading)
            )
        ]
    }

    private func insetSexSegmentedControl() -> Component {
        .containerComponent(properties: .init(
            component: .segmentedcontrolComponent(properties: .init(
                options: [
                    .init(label: "Male", value: "male"),
                    .init(label: "Female", value: "female"),
                    .init(label: "Rather not say", value: "rather-not-say")
                ],
                // Keep the user's choice when the screen re-renders with errors.
                selectedValue: experienceSelectionStateStore.selectedValues(for: SelectionKey.sex).first ?? "male",
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

    func hasEnteredValue(for measurement: BodyMeasurement) -> Bool {
        let value = experienceSelectionStateStore.selectedValues(for: measurement.selectionKey).first ?? ""
        return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

private extension PlaygroundBodyStatsInteractor {
    /// The mandatory measurements, in the order they appear on screen.
    enum BodyMeasurement: CaseIterable {
        case weight
        case height
        case age

        var label: String {
            switch self {
            case .weight: return "Weight"
            case .height: return "Height"
            case .age: return "Age"
            }
        }

        var placeholder: String {
            switch self {
            case .weight: return "88"
            case .height: return "180"
            case .age: return "32"
            }
        }

        var unit: String {
            switch self {
            case .weight: return "kg"
            case .height: return "cm"
            case .age: return "yrs"
            }
        }

        var keyboardType: TextFieldProperties.KeyboardType {
            switch self {
            case .weight: return .decimalPad
            case .height, .age: return .numberPad
            }
        }

        var selectionKey: String {
            switch self {
            case .weight: return SelectionKey.weight
            case .height: return SelectionKey.height
            case .age: return SelectionKey.age
            }
        }
    }
}
