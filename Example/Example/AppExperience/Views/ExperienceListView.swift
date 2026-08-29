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
        
        let experienceViewModel: ExperienceKit.ExperienceViewModel? = {
            return ExperienceViewModel(searchBar: .init(placeholder: "components and capabilities"),
                                       navigationBar: .init(title: "Experience Kit", displayMode: .large))
        }()
        
        experienceContainerView = ExperienceContainerView(experienceViewID: Experience.experienceList,
                                                          presenter: experienceContainerPresenter,
                                                          experienceRouterDelegate: nil,
                                                          experienceViewModel: experienceViewModel)
    }

    var body: some View {
        experienceContainerView
    }
}
