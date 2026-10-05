//
//  AnimationComponentInteractor.swift
//  Example
//

import ExperienceKit
import SwiftUI

final class AnimationComponentInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?

    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "Looping")),
            spinner(loop: true),
            .sectiontitleComponent(properties: .init(title: "Plays Once")),
            spinner(loop: false),
        ]))
    }

    func performDeferredWork(workId: any DeferredWorkID, values: [String], completion: @escaping (ExperienceType?) -> Void) {
        completion(nil)
    }

    private func spinner(loop: Bool) -> Component {
        .animationComponent(properties: .init(
            uri: AppExperienceAnimationProvider.AnimationURI.spinner,
            bundle: Bundle.main.bundleIdentifier ?? "",
            width: 88,
            height: 88,
            loop: loop
        ))
    }
}
