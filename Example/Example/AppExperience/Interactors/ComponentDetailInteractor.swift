//
//  ButtonComponentInteractor.swift
//  Example
//
//  Created by Sashen Singh on 13/07/2025.
//

import ExperienceKit
import SwiftUI

final class ComponentDetailInteractor: ExperienceInteractor {

    private let properties: [String: String]

    init(properties: [String: String]) {
        self.properties = properties
    }

    func load(completion: @escaping (ExperienceKit.ExperienceType) -> Void) {
        let experienceType: ExperienceType = {

            switch properties["componentTitle"] {
                case "welcome":
                    .fullScreen(component: .welcomeComponent(properties: welcomeProperties))
            default:
                fatalError(" \(String(describing: properties["componentTitle"])) component not defined")
            }
        }()

        completion(
            experienceType
        )
    }

    func performDeferredWork(workId: String, completion: @escaping () -> Void) {
    }
}

extension ComponentDetailInteractor {
    private var welcomeProperties: WelcomeProperties {
        return WelcomeProperties(image: .init(uri: "welcome-image",
                                              bundle: Bundle.main.bundleIdentifier ?? ""),
                                 description: .init(title: "mock description title",
                                                    subtitle: "mock description subtitle",
                                                    style: .large(.inverted)),
                                 primaryButton: .init(title: "mock primary button",
                                                      style: .secondary,
                                                      navigation: .init(navigationType: .push(Experience.welcomeComponent.rawValue),
                                                                        deferredLoadingWorkId: nil,
                                                                        additionalProperties: nil)),
                                 secondaryButton: .init(title: "mock secondary button",
                                                        style: .primary,
                                                        navigation: .init(navigationType: .dismiss,
                                                                          deferredLoadingWorkId: "test",
                                                                          additionalProperties: nil)))
    }
}
