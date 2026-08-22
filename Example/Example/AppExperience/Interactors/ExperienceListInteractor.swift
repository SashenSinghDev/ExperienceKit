//
//  ExperienceListInteractor.swift
//  Example
//
//  Created by Sashen Singh on 06/07/2025.
//

import ExperienceKit
import SwiftUI

final class ExperienceListInteractor: ExperienceInteractor {
    var navigationBarModel: ExperienceKit.NavigationBarModel? {
        return NavigationBarModel(title: "Experience Kit",
                                  displayMode: .large,
                                  searchBar: .init(placeholder: "components and capabilities"))
    }

    private var componetList: [Component] {
        return [
            .sectiontitleComponent(properties: .init(title: "Components", showBottomBorder: false)),
            .genericlistitemComponent(properties: .init(title: "Welcome",
                                                        navigation: .init(navigationType: .push(Experience.componentDetail),
                                                                          deferredLoadingWorkId: nil,
                                                                          additionalProperties: ["componentTitle": "welcome"]))),
            .separatorComponent(properties: .init(isFullWidth: false)),
            .genericlistitemComponent(properties: .init(title: "Button",
                                                        navigation: .init(navigationType: .push(Experience.componentDetail),
                                                                          deferredLoadingWorkId: nil,
                                                                          additionalProperties:  ["componentTitle": "button"]))),
            .separatorComponent(properties: .init(isFullWidth: false)),
            .genericlistitemComponent(properties: .init(title: "FullScreen",
                                                        navigation: .init(navigationType: .push(Experience.componentDetail),
                                                                          deferredLoadingWorkId: nil,
                                                                          additionalProperties:  ["componentTitle": "fullscreen"]))),
        ]
    }

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: componetList))
    }
    
    func performDeferredWork(workId: any ExperienceKit.DeferredWorkID, completion: @escaping (ExperienceKit.ExperienceType?) -> Void) {
        guard navigationBarModel != nil else { return }

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
