//
//  HorizontalStackComponentInteractor.swift
//  Example
//
//  Created by Claude on 27/09/2026.
//

import ExperienceKit
import SwiftUI

final class HorizontalStackComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Fill equally")),
            insetHorizontalStack(
                components: [
                    measurementField(label: "Weight", placeholder: "88", unit: "kg"),
                    measurementField(label: "Height", placeholder: "180", unit: "cm"),
                    measurementField(label: "Age", placeholder: "32", unit: "yrs")
                ],
                spacing: .small,
                distribution: .fillEqually
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Leading")),
            insetHorizontalStack(
                components: [
                    text("Kcal"),
                    text("Protein"),
                    text("Carbs")
                ],
                spacing: .medium,
                distribution: .leading
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Centre aligned")),
            insetHorizontalStack(
                components: [
                    text("Short"),
                    text("A longer label that wraps onto more than one line"),
                    text("Short")
                ],
                spacing: .small,
                alignment: .center,
                distribution: .fillEqually
            )
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func insetHorizontalStack(components: [Component],
                                      spacing: HorizontalStackProperties.Spacing,
                                      alignment: HorizontalStackProperties.Alignment = .top,
                                      distribution: HorizontalStackProperties.Distribution) -> Component {
        .containerComponent(properties: .init(
            component: .horizontalstackComponent(properties: .init(
                components: components,
                spacing: spacing,
                alignment: alignment,
                distribution: distribution
            )),
            horizontalSpacing: .medium)
        )
    }

    private func measurementField(label: String, placeholder: String, unit: String) -> Component {
        .textfieldComponent(properties: .init(
            keyboardType: .numberPad,
            label: label,
            placeholder: placeholder,
            showsClearButton: false,
            unit: unit
        ))
    }

    private func text(_ title: String) -> Component {
        .textComponent(properties: .init(
            title: title,
            font: .body,
            weight: .regular,
            alignment: .leading,
            foregroundStyle: .primary
        ))
    }
}
