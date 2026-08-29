//
//  ExperienceContentView.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

import SwiftUI

public protocol ExperienceContentView: View {
    var experienceContainerView: ExperienceContainerView { get }
    var experienceContainerPresenter: ExperienceContainerPresenter { get }
}
