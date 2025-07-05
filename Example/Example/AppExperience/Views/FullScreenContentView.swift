//
//  FullScreenContentView.swift
//  Example
//
//  Created by Sashen Singh on 14/12/2024.
//

import SwiftUI
import ExperienceKit

struct FullScreenContentView: ExperienceContentView {
    internal let experienceContainerView: ExperienceContainerView
    internal let experienceContainerPresenter: ExperienceContainerPresenter

    init() {
        experienceContainerPresenter = ExperienceContainerPresenter(registers: allRegisters,
                                                                    experienceProvider: AppExperienceProvider())
        experienceContainerView = ExperienceContainerView(experienceViewID: Experience.welcome.rawValue,
                                                          presenter: experienceContainerPresenter,
                                                          experienceRouterDelegate: nil)
    }

    var body: some View {
        experienceContainerView
    }
}


