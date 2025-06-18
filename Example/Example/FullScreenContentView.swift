//
//  FullScreenContentView.swift
//  Example
//
//  Created by Sashen Singh on 14/12/2024.
//

import SwiftUI
import ExperienceKit

struct FullScreenContentView: View {
    private let experienceContainerView: ExperienceContainerView

    init() {
        let presenter = ExperienceContainerPresenter(registers: allRegisters,
                                                     experienceProvider: AppExperienceProvider())
        experienceContainerView = ExperienceContainerView(experienceViewID: "fullScreen",
                                                          presenter: presenter)
    }

    var body: some View {
        experienceContainerView
    }
}


