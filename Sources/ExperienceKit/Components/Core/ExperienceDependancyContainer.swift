//
//  ExperienceDependancyContainer.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/06/2025.
//

import Foundation

public protocol ExperienceDependancyContainer {
    func experienceView(for id: String, router: NavigationRouter, viewModelID: UUID) -> ExperienceView<ExperiencePresenter>
}
