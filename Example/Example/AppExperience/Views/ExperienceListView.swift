//
//  ExperienceListView.swift
//  Example
//
//  Created by Sashen Singh on 06/07/2025.
//

import SwiftUI
import ExperienceKit

struct ExperienceListView: ExperienceContentView {
    internal let experienceContainerView: ExperienceContainerView
    internal let experienceContainerPresenter: ExperienceContainerPresenter

    init() {
        experienceContainerPresenter = ExperienceContainerPresenter(registers: allRegisters,
                                                                    experienceProvider: AppExperienceProvider())
        
        let navigationBarModel: ExperienceKit.NavigationBarModel? = {
            return NavigationBarModel(title: "Experience Kit",
                                      displayMode: .large,
                                      searchBar: .init(placeholder: "components and capabilities"))
        }()
        
        experienceContainerView = ExperienceContainerView(experienceViewID: Experience.experienceList,
                                                          presenter: experienceContainerPresenter,
                                                          experienceRouterDelegate: nil,
                                                          navigationBarModel: navigationBarModel)
    }

    var body: some View {
        experienceContainerView
    }
}
