//
//  FullScreenContentView.swift
//  Example
//
//  Created by Sashen Singh on 14/12/2024.
//

import SwiftUI
import ExperienceKit

struct FullScreenContentView: View {
    private let dependancyContainer: DependancyContainer
    private let experienceContainerView: ExperienceContainerView

    init() {
        self.dependancyContainer = DependancyContainer(dependencies: DependancyServiceManager())
        experienceContainerView = ExperienceContainerView(experienceViewID: "fullScreen",
                                                          dependancyContainer: dependancyContainer)
    }

    var body: some View {
        experienceContainerView
    }
}


