//
//  ExperienceListView.swift
//  Example
//
//  Created by Sashen Singh on 06/07/2025.
//

import SwiftUI
import ExperienceKit

struct ExperienceListView: View {
    private let experienceRootView: ExperienceRootView

    init() {
        let experienceViewModel: ExperienceKit.ExperienceViewModel? = {
            return ExperienceViewModel(searchBar: .init(placeholder: "components and capabilities"),
                                       navigationBar: .init(title: "Experience Kit", displayMode: .large))
        }()

        experienceRootView = ExperienceRootView(root: Experience.experienceList,
                                                provider: AppExperienceProvider(),
                                                configuration: experienceViewModel)
    }

    var body: some View {
        experienceRootView
    }
}
