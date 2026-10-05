//
//  DataTableComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 02/10/2026.
//

import ExperienceKit
import SwiftUI

final class DataTableComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Weekly macros")),
            insetDataTable(
                columns: ["Day", "Fat", "Carbs", "Prot", "Cals"],
                rows: [
                    .init(label: "Mon", values: ["60g", "345g", "210g", "2,775"], isMarked: true),
                    .init(label: "Tue", values: ["55g", "195g", "170g", "1,942"]),
                    .init(label: "Wed", values: ["55g", "195g", "170g", "1,942"]),
                    .init(label: "Thu", values: ["60g", "345g", "210g", "2,775"], isMarked: true),
                    .init(label: "Fri", values: ["55g", "195g", "170g", "1,942"]),
                    .init(label: "Sat", values: ["55g", "195g", "170g", "1,942"]),
                    .init(label: "Sun", values: ["55g", "195g", "170g", "1,942"])
                ],
                markerLabel: "High-carb day"
            ),
            .sectiontitleComponent(properties: .init(title: "Three rows")),
            insetDataTable(
                columns: ["Meal", "Fat", "Carbs", "Prot", "Cals"],
                rows: mealRows
            ),
            .sectiontitleComponent(properties: .init(title: "No header")),
            insetDataTable(
                columns: nil,
                rows: mealRows
            ),
            .spacerComponent(properties: .init(size: .large))
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private var mealRows: [DataTableProperties.Row] {
        [
            .init(label: "Breakfast", values: ["18g", "62g", "34g", "546"]),
            .init(label: "Lunch", values: ["22g", "80g", "48g", "710"]),
            .init(label: "Dinner", values: ["15g", "53g", "88g", "699"])
        ]
    }

    private func insetDataTable(columns: [String]?,
                                rows: [DataTableProperties.Row],
                                markerLabel: String? = nil) -> Component {
        .containerComponent(properties: .init(
            component: .datatableComponent(properties: .init(
                columns: columns,
                rows: rows,
                markerLabel: markerLabel
            )),
            horizontalSpacing: .medium)
        )
    }
}
