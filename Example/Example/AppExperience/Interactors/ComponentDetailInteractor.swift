////
////  ButtonComponentInteractor.swift
////  Example
////
////  Created by Sashen Singh on 13/07/2025.
////
//
//import ExperienceKit
//import SwiftUI
//
//final class ComponentDetailInteractor: ExperienceInteractor {    
//    internal let navigationBarModel: NavigationBarModel?
//    
//    init(navigationBarModel: NavigationBarModel?) {
//        self.navigationBarModel = navigationBarModel
//    }
//    
//    func load(completion: @escaping (ExperienceKit.ExperienceType) -> Void) {
//        let experienceType: ExperienceType = {
//            
//            switch properties["componentTitle"] {
//            case "welcome":
//                welcomeExperience
//            case "button":
//                buttonExperience
//            case "fullscreen":
//                fullScreenExperience
//            default:
//                fatalError(" \(String(describing: properties["componentTitle"])) component not defined")
//            }
//        }()
//        
//        completion(
//            experienceType
//        )
//    }
//    
//    func performDeferredWork(workId: any ExperienceKit.DeferredWorkID, completion: @escaping (ExperienceKit.ExperienceType?) -> Void) {
//        completion(nil)
//    }
//}
//
//extension ComponentDetailInteractor {
//    
//    private var welcomeExperience: ExperienceType {
//        let properties = WelcomeProperties(
//            image: .init(uri: "welcome-image",
//                         bundle: Bundle.main.bundleIdentifier ?? ""),
//            description: .init(title: "mock description title",
//                               subtitle: "mock description subtitle",
//                               style: .large(.inverted)),
//            primaryButton: .init(title: "mock primary button",
//                                 style: .secondary,
//                                 isFullWidth: true,
//                                 navigation: .init(navigationType: .modal(Experience.welcomeComponent),
//                                                   deferredLoadingWorkId: nil,
//                                                   additionalProperties: nil,
//                                                   navigationBarModel: nil)),
//            secondaryButton: .init(title: "mock secondary button",
//                                   style: .primary,
//                                   isFullWidth: true,
//                                   navigation: .init(navigationType: .pop,
//                                                     deferredLoadingWorkId: DeferredWork.loadData,
//                                                     additionalProperties: nil,
//                                                     navigationBarModel: nil))
//        )
//        
//        return .fullScreen(component: .welcomeComponent(properties: properties))
//    }
//    
//    private var fullScreenExperience: ExperienceType {
//        let properties = FullScreenProperties(
//            image: .init(uri: "welcome-image",
//                         bundle: Bundle.main.bundleIdentifier ?? ""),
//            horizontalAlignment: .center,
//            verticalAlignment: .top,
//            topComponents: [
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//            ],
//            middleComponents: [
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//            ],
//            bottomComponents: [
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//                .buttonComponent(properties: .init(title: "buttonTitle",
//                                                   style: .secondary,
//                                                   isFullWidth: false,
//                                                   navigation: .init(navigationType: .pop,
//                                                                     deferredLoadingWorkId: nil,
//                                                                     additionalProperties: [:],
//                                                                     navigationBarModel: nil))),
//            ]
//        )
//        return .fullScreen(component: .fullscreenComponent(properties: properties))
//    }
//    
//    private var buttonExperience: ExperienceType {
//        return .scrollable(components: [
//            .sectiontitleComponent(properties: .init(title: "PrimaryButton", showBottomBorder: false)),
//            .buttonComponent(properties: .init(title: "PrimaryButton",
//                                               style: .primary,
//                                               isFullWidth: false,
//                                               navigation: .init(navigationType: .pop,
//                                                                 deferredLoadingWorkId: nil,
//                                                                 additionalProperties: nil,
//                                                                 navigationBarModel: nil))),
//            .sectiontitleComponent(properties: .init(title: "SecondaryButton", showBottomBorder: false)),
//            .containerComponent(properties: .init(
//                component: .buttonComponent(properties: .init(title: "Secondary",
//                                                              style: .secondary,
//                                                              isFullWidth: false,
//                                                              navigation: .init(navigationType: .pop,
//                                                                                deferredLoadingWorkId: nil,
//                                                                                additionalProperties: nil,
//                                                                                navigationBarModel: nil)))))
//        ])
//    }
//}
