//
//  WelcomeInteractor.swift
//  Example
//
//  Created by Sashen Singh on 18/06/2025.
//

import ExperienceKit
import SwiftUI

final class WelcomeComponentInteractor: ExperienceInteractor {
    var navigationBarModel: ExperienceKit.NavigationBarModel?
    
    init() {}

    func load(completion: @escaping (ExperienceType) -> Void) {

        let welcomeProperties = WelcomeProperties(image: .init(uri: "welcome-image",
                                                               bundle: Bundle.main.bundleIdentifier ?? ""),
                                                  description: .init(title: "Welcome to 👋 GymBru",
                                                                     subtitle: "A personal trainer in your pocket",
                                                                     style: .large(.inverted)),
                                                  primaryButton: .init(title: "Log In",
                                                                       style: .secondary,
                                                                       isFullWidth: true,
                                                                       navigation: .init(navigationType: .push(Experience.welcomeComponent.rawValue),
                                                                                         deferredLoadingWorkId: nil, additionalProperties: nil)),
                                                  secondaryButton: .init(title: "Get Started",
                                                                         style: .primary,
                                                                         isFullWidth: true,
                                                                         navigation: .init(navigationType: .dismiss, deferredLoadingWorkId: "test", additionalProperties: nil)))

        completion(
            .fullScreen(component: .init(contentType: "welcomeComponent", properties: welcomeProperties, id: UUID()))
        )
    }

    func performDeferredWork(workId: String, completion: @escaping (ExperienceType?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(nil)
        }
    }
}
