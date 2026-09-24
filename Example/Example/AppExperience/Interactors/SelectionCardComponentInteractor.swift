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
            .sectiontitleComponent(properties: .init(title: "Default")),
            .selectioncardComponent(properties: .init(
                title: "Monthly",
                subtitle: "Billed monthly",
                value: "$9.99",
                isSelected: false,
                badgeText: nil,
                navigation: nil
            )),
            .sectiontitleComponent(properties: .init(title: "Selected")),
            .selectioncardComponent(properties: .init(
                title: "Annual",
                subtitle: "Billed once a year",
                value: "$39.99",
                isSelected: true,
                badgeText: "Save 63%",
                navigation: nil
            )),
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }
}
