//
//  HorizontalContainerComponentInteractor.swift
//  Example
//
//  Created by Claude on 27/09/2026.
//

import ExperienceKit
import SwiftUI

final class HorizontalContainerComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Fill equally")),
            insetHorizontalContainer(
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
            insetHorizontalContainer(
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
            insetHorizontalContainer(
                components: [
                    text("Short"),
                    text("A longer label that wraps onto more than one line"),
                    text("Short")
                ],
                spacing: .small,
                alignment: .center,
                distribution: .fillEqually
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Scrollable")),
            // Not wrapped in a container: the content inset lines the first card
            // up with the page margin while the row still scrolls edge to edge.
            .horizontalcontainerComponent(properties: .init(
                components: [
                    card(title: "The 30-Day Cutting Pack",
                         subtitle: "Six high-volume dinners on rotation for a month.",
                         value: "£8.99"),
                    card(title: "High-Protein Batch Cook",
                         subtitle: "Six one-pot meals that hold in the fridge for four days.",
                         value: "£6.99"),
                    card(title: "Mornings, Sorted",
                         subtitle: "Five make-ahead breakfasts you build on Sunday.",
                         value: "£4.99")
                ],
                spacing: .small,
                distribution: .scrollable,
                contentInset: .medium,
                itemWidth: 228
            ))
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func insetHorizontalContainer(components: [Component],
                                      spacing: HorizontalContainerProperties.Spacing,
                                      alignment: HorizontalContainerProperties.Alignment = .top,
                                      distribution: HorizontalContainerProperties.Distribution) -> Component {
        .containerComponent(properties: .init(
            component: .horizontalcontainerComponent(properties: .init(
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

    private func card(title: String, subtitle: String, value: String) -> Component {
        .selectioncardComponent(properties: .init(
            title: title,
            subtitle: subtitle,
            value: value,
            isSelected: false,
            badgeText: nil,
            selectionId: title,
            selectionGroupId: "horizontal-container-demo",
            navigation: nil
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
