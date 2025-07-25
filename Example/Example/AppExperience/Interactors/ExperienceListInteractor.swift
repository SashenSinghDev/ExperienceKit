//
//  ExperienceListInteractor.swift
//  Example
//
//  Created by Sashen Singh on 06/07/2025.
//

import ExperienceKit
import SwiftUI

final class ExperienceListInteractor: ExperienceInteractor {

    private var componetList: [Component] {
        return [
            .sectionTitleComponent(title: "Components", showBottomBorder: false),
            .genericListItemComponent(title: "Welcome",
                                      navigation: .init(navigationType: .push(Experience.componentDetail.rawValue),
                                                        deferredLoadingWorkId: nil,
                                                        additionalProperties: ["componentTitle": "welcome"])),
            .separatorComponent(properties: .init(isFullWidth: false)),
            .genericListItemComponent(title: "Button",
                                      navigation: .init(navigationType: .push(Experience.componentDetail.rawValue),
                                                        deferredLoadingWorkId: nil,
                                                        additionalProperties: ["componentTitle": "button"]))
        ]
    }

    private let navigationBarModel = NavigationBarModel(title: "Experience Kit",
                                                        displayMode: .large,
                                                        searchBar: .init(placeholder: "components and capabilities"))

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollableWithNavigationProperties(components: componetList, navigationBarModel: navigationBarModel))
    }

    func performDeferredWork(workId: String, completion: @escaping (ExperienceType?) -> Void) {

        let searchText = workId
        var filteredComponentList: [Component] = {
            guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return componetList
            }

            return componetList.filter { component in
                guard let properties = component.properties as? GenericListItemProperties else { return false }
                return properties.title.localizedCaseInsensitiveContains(searchText) == true
            }
        }()

        completion(.scrollableWithNavigationProperties(components: filteredComponentList, navigationBarModel: navigationBarModel))
    }
}
