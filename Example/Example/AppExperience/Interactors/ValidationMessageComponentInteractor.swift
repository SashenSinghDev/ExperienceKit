//
//  ValidationMessageComponentInteractor.swift
//  Example
//
//  Created by Claude on 27/09/2026.
//

import ExperienceKit
import SwiftUI

final class ValidationMessageComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Missing fields")),
            insetText("Type into a field: its border and its name in the message clear."),
            .spacerComponent(properties: .init(size: .small)),
            insetRow(fields: [
                (label: "First name", placeholder: "Jordan", key: SelectionKey.firstName),
                (label: "Last name", placeholder: "Casey", key: SelectionKey.lastName)
            ]),
            insetValidationMessage(
                fields: [
                    .init(name: "first name", selectionKey: SelectionKey.firstName),
                    .init(name: "last name", selectionKey: SelectionKey.lastName)
                ],
                template: "Add your {fields} to continue."
            ),
            .spacerComponent(properties: .init(size: .large)),
            .sectiontitleComponent(properties: .init(title: "Three fields")),
            insetRow(fields: [
                (label: "Weight", placeholder: "88", key: SelectionKey.weight),
                (label: "Height", placeholder: "180", key: SelectionKey.height),
                (label: "Age", placeholder: "32", key: SelectionKey.age)
            ]),
            insetValidationMessage(
                fields: [
                    .init(name: "weight", selectionKey: SelectionKey.weight),
                    .init(name: "height", selectionKey: SelectionKey.height),
                    .init(name: "age", selectionKey: SelectionKey.age)
                ],
                template: "Add your {fields} to continue."
            )
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func insetText(_ title: String) -> Component {
        .containerComponent(properties: .init(
            component: .textComponent(properties: .init(
                title: title,
                font: .footnote,
                weight: .regular,
                alignment: .leading,
                foregroundStyle: .secondary)
            ),
            horizontalSpacing: .medium,
            alignment: .leading)
        )
    }

    private func insetRow(fields: [(label: String, placeholder: String, key: String)]) -> Component {
        .containerComponent(properties: .init(
            component: .horizontalcontainerComponent(properties: .init(
                components: fields.map {
                    .textfieldComponent(properties: .init(
                        state: .error,
                        label: $0.label,
                        placeholder: $0.placeholder,
                        showsClearButton: false,
                        selectionKey: $0.key)
                    )
                },
                spacing: .small,
                alignment: .top,
                distribution: .fillEqually)
            ),
            horizontalSpacing: .medium)
        )
    }

    private func insetValidationMessage(fields: [ValidationMessageProperties.Field],
                                        template: String) -> Component {
        .containerComponent(properties: .init(
            component: .validationmessageComponent(properties: .init(
                fields: fields,
                template: template)
            ),
            horizontalSpacing: .medium,
            alignment: .leading)
        )
    }
}

private extension ValidationMessageComponentInteractor {
    enum SelectionKey {
        static let firstName = "validation-first-name"
        static let lastName = "validation-last-name"
        static let weight = "validation-weight"
        static let height = "validation-height"
        static let age = "validation-age"
    }
}
