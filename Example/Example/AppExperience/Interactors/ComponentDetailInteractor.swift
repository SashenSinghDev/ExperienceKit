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
        case "fullscreen":
            return .init(title: "", displayMode: .inline, searchBar: nil)
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
            case "fullscreen":
                fullScreenExperience
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

    private var fullScreenExperience: ExperienceType {
        let properties = FullScreenProperties(image: .init(uri: "welcome-image",
                                                           bundle: Bundle.main.bundleIdentifier ?? ""),
                                              horizontalAlignment: .center,
                                              verticalAlignment: .top,
                                              topComponents: [
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                              ],
                                              middleComponents: [
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                              ],
                                              bottomComponents: [
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                                .buttonComponent(properties: .init(title: "buttonTitle",
                                                                                   style: .secondary,
                                                                                   isFullWidth: false,
                                                                                   navigation: .init(navigationType: .pop,
                                                                                                     deferredLoadingWorkId: nil,
                                                                                                     additionalProperties: [:]))),
                                              ]
        )
        return .fullScreen(component: .fullscreenComponent(properties: properties))
    }

    private var buttonExperience: ExperienceType {
        return .scrollable(components: [
            .sectiontitleComponent(properties: .init(title: "PrimaryButton", showBottomBorder: false)),
            .buttonComponent(properties: .init(title: "PrimaryButton",
                                               style: .primary,
                                               isFullWidth: false,
                                               navigation: .init(navigationType: .pop,
                                                                 deferredLoadingWorkId: nil,
                                                                 additionalProperties: nil))),
            .sectiontitleComponent(properties: .init(title: "SecondaryButton", showBottomBorder: false)),
            .containerComponent(properties: .init(
                component: .buttonComponent(properties: .init(title: "Secondary",
                                                              style: .secondary,
                                                              isFullWidth: false,
                                                              navigation: .init(navigationType: .pop,
                                                                                deferredLoadingWorkId: nil,
                                                                                additionalProperties: nil)))))
        ])
    }
}
