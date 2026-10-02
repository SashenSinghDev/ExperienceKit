//
//  PlaygroundPlanRevealInteractor.swift
//  Example
//
//  Created by Claude on 02/10/2026.
//

import ExperienceKit
import SwiftUI

final class PlaygroundPlanRevealInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    /// Figma: 08 Plan reveal · Carb cycling.
    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.fullScreen(properties: .init(
            image: nil,
            topComponents: [
                .spacerComponent(properties: .init(size: .large)),
                insetText(
                    title: "Your starting plan",
                    font: .title1,
                    weight: .bold,
                    foregroundStyle: .primary
                ),
                .spacerComponent(properties: .init(size: .small)),
                insetText(
                    title: "\(Plan.maintenanceCalories) cal to maintain",
                    font: .headline,
                    weight: .semibold,
                    foregroundStyle: .primary
                ),
                insetText(
                    title: Plan.summary,
                    font: .subheadline,
                    weight: .regular,
                    foregroundStyle: .secondary
                ),
                .spacerComponent(properties: .init(size: .medium)),
                .containerComponent(properties: .init(
                    component: .datatableComponent(properties: .init(
                        columns: ["Day", "Fat", "Carbs", "Prot", "Cals"],
                        rows: Plan.week.map(\.row),
                        markerLabel: "High-carb day")
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .medium))
            ],
            middleComponents: [],
            bottomComponents: [
                .containerComponent(properties: .init(
                    component: .buttonComponent(properties: .init(
                        title: "Start tracking",
                        style: .primary,
                        // The flow ends here until the tracking screens exist.
                        navigation: .init(
                            navigationType: .dismiss,
                            deferredLoadingWorkId: nil,
                            experienceViewModel: nil))
                    ),
                    horizontalSpacing: .medium)
                ),
                .spacerComponent(properties: .init(size: .small))
            ]
        )))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
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
}

private extension PlaygroundPlanRevealInteractor {
    /// Stands in for the plan the calculating screen would hand over.
    enum Plan {
        static let maintenanceCalories = "2,775"

        static let summary = "Five days at a 30% deficit, two days back at full maintenance to keep training hard. High-carb days start on Monday and Thursday — swap them whenever."

        static let week: [Day] = [
            .init(name: "Mon", targets: .highCarb),
            .init(name: "Tue", targets: .lowCarb),
            .init(name: "Wed", targets: .lowCarb),
            .init(name: "Thu", targets: .highCarb),
            .init(name: "Fri", targets: .lowCarb),
            .init(name: "Sat", targets: .lowCarb),
            .init(name: "Sun", targets: .lowCarb)
        ]
    }

    struct Day {
        let name: String
        let targets: Targets

        var row: DataTableProperties.Row {
            .init(label: name,
                  values: [targets.fat, targets.carbs, targets.protein, targets.calories],
                  isMarked: targets.isHighCarb)
        }
    }

    /// One day's macro targets, already formatted for display.
    struct Targets {
        let fat: String
        let carbs: String
        let protein: String
        let calories: String
        let isHighCarb: Bool

        /// Full maintenance.
        static let highCarb = Targets(fat: "60g", carbs: "345g", protein: "210g", calories: "2,775", isHighCarb: true)
        /// 30% deficit.
        static let lowCarb = Targets(fat: "55g", carbs: "195g", protein: "170g", calories: "1,942", isHighCarb: false)
    }
}
