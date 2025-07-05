//
//  WelcomeInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class WelcomeInteractor: ExperienceInteractor {

    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {

        let welcomeProperties = WelcomeProperties(image: .init(uri: "welcome-image",
                                                               bundle: Bundle.main.bundleIdentifier ?? ""),
                                                  description: .init(title: "Welcome to 👋 GymBru",
                                                                     subtitle: "A personal trainer in your pocket",
                                                                     style: .large(.inverted)),
                                                  primaryButton: .init(title: "Log In",
                                                                       style: .secondary,
                                                                       navigation: .init(navigationType: .push(Experience.welcome.rawValue),
                                                                                         deferredLoadingWorkId: nil)),
                                                  secondaryButton: .init(title: "Get Started",
                                                                         style: .primary,
                                                                         navigation: .init(navigationType: .popToRoot, deferredLoadingWorkId: "test")))

        completion(
            .fullScreen(component: .init(contentType: "welcomeComponent", properties: welcomeProperties, id: UUID()))
        )
    }

    func performDeferredWork(workId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}
