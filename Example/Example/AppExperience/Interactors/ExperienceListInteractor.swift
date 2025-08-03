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

    func load(completion: @escaping (ExperienceType) -> Void) {
        completion(.scrollable(components: componetList))
    }

    func performDeferredWork(workId: String, completion: @escaping (ExperienceType?) -> Void) {
        guard let navigationBarModel = navigationBarModel else { return }

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

        completion(.scrollable(components: filteredComponentList))
    }
}
