//
//  SelectionCardComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 24/09/2026.
//

import ExperienceKit
import SwiftUI

final class SelectionCardComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Plans")),
            .containerComponent(properties: .init(
                component: .selectioncardComponent(properties: .init(
                    title: "Yearly",
                    subtitle: "£3.33 a month, billed once",
                    value: "£39.99",
                    isSelected: true,
                    badgeText: "Save 44%",
                    selectionId: "yearly",
                    selectionGroupId: "plans",
                    navigation: nil
                )),
                horizontalSpacing: .medium
            )),
            .spacerComponent(properties: .init(size: .medium)),
            .containerComponent(properties: .init(
                component: .selectioncardComponent(properties: .init(
                    title: "Monthly",
                    subtitle: "Cancel whenever you like",
                    value: "£5.99",
                    isSelected: false,
                    badgeText: nil,
                    selectionId: "monthly",
                    selectionGroupId: "plans",
                    navigation: nil
                )),
                horizontalSpacing: .medium
            )),
            .sectiontitleComponent(properties: .init(title: "Add ons")),
            .containerComponent(properties: .init(
                component: .selectioncardComponent(properties: .init(
                    title: "Extra baggage",
                    subtitle: "Add one checked bag",
                    value: "£12.00",
                    isSelected: false,
                    badgeText: nil,
                    selectionId: "extra-baggage",
                    selectionGroupId: "add-ons",
                    selectionMode: .multiple,
                    navigation: nil
                )),
                horizontalSpacing: .medium
            )),
            .spacerComponent(properties: .init(size: .medium)),
            .containerComponent(properties: .init(
                component: .selectioncardComponent(properties: .init(
                    title: "Priority boarding",
                    subtitle: "Board before general boarding",
                    value: "£4.99",
                    isSelected: true,
                    badgeText: nil,
                    selectionId: "priority-boarding",
                    selectionGroupId: "add-ons",
                    selectionMode: .multiple,
                    navigation: nil
                )),
                horizontalSpacing: .medium
            )),
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }
}
