//
//  HomeContainerContentView.swift
//  Example
//
//  Created by Sashen Singh on 28/06/2025.
//

import SwiftUI
import ExperienceKit

struct HomeContainerContentView: ExperienceContentView {
    internal let experienceContainerView: ExperienceContainerView
    internal let experienceContainerPresenter: ExperienceContainerPresenter

    init() {
        experienceContainerPresenter = ExperienceContainerPresenter(registers: allRegisters,
                                                                    experienceProvider: AppExperienceProvider())
        experienceContainerView = ExperienceContainerView(experienceViewID: Experience.homeContainer.rawValue,
                                                          presenter: experienceContainerPresenter,
                                                          experienceRouterDelegate: nil)
    }

    var body: some View {
        experienceContainerView
    }
}
