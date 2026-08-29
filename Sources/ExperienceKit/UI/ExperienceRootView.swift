//
//  ExperienceRootView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 29/08/2026.
//

import SwiftUI

public struct ExperienceRootView: View {
    private let containerView: ExperienceContainerView

    public init(root experienceViewID: ExperienceID,
                provider experienceProvider: ExperienceProvider,
                configuration experienceViewModel: ExperienceViewModel? = nil,
                registers: [ComponentRegister] = allRegisters,
                experienceRouterDelegate: ExperienceRouterDelegate? = nil) {
        let presenter = ExperienceContainerPresenter(registers: registers,
                                                     experienceProvider: experienceProvider)

        self.containerView = ExperienceContainerView(experienceViewID: experienceViewID,
                                                     presenter: presenter,
                                                     experienceRouterDelegate: experienceRouterDelegate,
                                                     experienceViewModel: experienceViewModel)
    }

    public var body: some View {
        containerView
    }
}
