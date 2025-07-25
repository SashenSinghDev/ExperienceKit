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
        experienceContainerView = ExperienceContainerView(experienceViewID: Experience.experienceList.rawValue,
                                                          presenter: experienceContainerPresenter,
                                                          experienceRouterDelegate: nil, properties: nil)
    }

    var body: some View {
        experienceContainerView
    }
}
