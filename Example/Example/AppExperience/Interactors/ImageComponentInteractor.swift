//
//  ImageComponentInteractor.swift
//  Example
//
//  Created by Sashen Suneel Singh on 24/09/2026.
//

import ExperienceKit
import SwiftUI

final class ImageComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Circle Image")),
            .imageComponent(properties: .init(
                uri: "circle_image",
                bundle: Bundle.main.bundleIdentifier ?? "",
                width: 88,
                height: 88
            )),
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }
}
