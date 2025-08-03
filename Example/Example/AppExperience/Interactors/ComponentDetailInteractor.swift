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

    var navigationBarModel: NavigationBarModel? {
        switch properties["componentTitle"] {
        case "welcome":
            return nil
        case "button":
            return .init(title: "Buttons", displayMode: .inline, searchBar: nil)
        default:
            fatalError(" \(String(describing: properties["componentTitle"])) component not defined")
        }
    }

    init(properties: [String: String]) {
        self.properties = properties
    }

    func load(completion: @escaping (ExperienceKit.ExperienceType) -> Void) {
        let experienceType: ExperienceType = {

            switch properties["componentTitle"] {
            case "welcome":
                welcomeExperience
            case "button":
                buttonExperience
            default:
                fatalError(" \(String(describing: properties["componentTitle"])) component not defined")
            }
        }()

        completion(
            experienceType
        )
    }

    func performDeferredWork(workId: String, completion: @escaping (ExperienceType?) -> Void) {
    }
}

extension ComponentDetailInteractor {

    private var welcomeExperience: ExperienceType {
        let properties = WelcomeProperties(image: .init(uri: "welcome-image",
                                                               bundle: Bundle.main.bundleIdentifier ?? ""),
                                                  description: .init(title: "mock description title",
                                                                     subtitle: "mock description subtitle",
                                                                     style: .large(.inverted)),
                                                  primaryButton: .init(title: "mock primary button",
                                                                       style: .secondary,
                                                                       isFullWidth: true,
                                                                       navigation: .init(navigationType: .push(Experience.welcomeComponent.rawValue),
                                                                                         deferredLoadingWorkId: nil,
                                                                                         additionalProperties: nil)),
                                                  secondaryButton: .init(title: "mock secondary button",
                                                                         style: .primary,
                                                                         isFullWidth: true,
                                                                         navigation: .init(navigationType: .dismiss,
                                                                                           deferredLoadingWorkId: "test",
                                                                                           additionalProperties: nil)))

        return .fullScreen(component: .welcomeComponent(properties: properties))
    }

    private var buttonExperience: ExperienceType {
        return .scrollable(components: [
            .sectionTitleComponent(title: "PrimaryButton", showBottomBorder: false),
            .buttonComponent(title: "PrimaryButton",
                             style: .primary,
                             isFullWidth: false,
                             navigation: .init(navigationType: .pop, deferredLoadingWorkId: nil, additionalProperties: nil)),
            .sectionTitleComponent(title: "SecondaryButton", showBottomBorder: false),
            .buttonComponent(title: "Secondary",
                             style: .secondary,
                             isFullWidth: false,
                             navigation: .init(navigationType: .pop, deferredLoadingWorkId: nil, additionalProperties: nil))
        ])
    }
}
