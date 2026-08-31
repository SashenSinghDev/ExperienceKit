//
//  ExperienceListInteractor.swift
//  Example
//
//  Created by Sashen Singh on 06/07/2025.
//

import ExperienceKit
import SwiftUI

final class ExperienceListInteractor: ExperienceInteractor {
    internal let experienceViewModel: ExperienceKit.ExperienceViewModel?
    
    init(experienceViewModel: ExperienceKit.ExperienceViewModel?) {
        self.experienceViewModel = experienceViewModel
    }
    
    private var componetList: [Component] {
        return [
            .sectiontitleComponent(properties: .init(
                title: "Components")
            ),
            .genericlistitemComponent(properties: .init(
                title: "Welcome",
                navigation: .init(
                    navigationType: .push(Experience.welcomeComponent),
                    deferredLoadingWorkId: nil,
                    experienceViewModel: nil,
                ))
            ),
            .separatorComponent(properties: .init(isFullWidth: false)),
            .genericlistitemComponent(properties: .init(
                title: "Buttons",
                navigation: .init(
                    navigationType: .push(Experience.buttonComponent),
                    deferredLoadingWorkId: nil,
                    experienceViewModel: .init(
                        searchBar: nil,
                        navigationBar: .init(title: "Buttons", displayMode: .inline))))
            ),
            .separatorComponent(properties: .init(isFullWidth: false)),
            .genericlistitemComponent(properties: .init(
                title: "FullScreen",
                navigation: .init(
                    navigationType: .push(Experience.fullScreenComponent),
                    deferredLoadingWorkId: nil,
                    experienceViewModel: .init(
                        searchBar: nil,
                        navigationBar: .init(title: "", displayMode: .inline))))
            ),
            .sectiontitleComponent(properties: .init(
                title: "Capabilities")
            ),
            .genericlistitemComponent(properties: .init(
                title: "Navigation",
                navigation: .init(
                    navigationType: .push(Experience.navigationCapability),
                    deferredLoadingWorkId: nil,
                    experienceViewModel: .init(
                        searchBar: nil,
                        navigationBar: .init(title: "Navigation", displayMode: .automatic))))
            ),
        ]
    }
    
    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: componetList))
    }
    
    func performDeferredWork(workId: any ExperienceKit.DeferredWorkID, completion: @escaping (ExperienceKit.ExperienceType?) -> Void) {
        guard experienceViewModel != nil else { return }
        
        let searchText = workId.rawValue
        let filteredComponentList: [Component] = {
            guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return componetList
            }
            
            return componetList.filter { component in
                guard let properties = component.properties as? GenericListItemProperties else { return false }
                return properties.title.localizedCaseInsensitiveContains(searchText) == true
            }
        }()
        
        completion(.scrollable(components: filteredComponentList))
    }
}
