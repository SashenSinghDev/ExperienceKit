//
//  ExperienceType.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 14/12/2024.
//

public enum ExperienceType {
    case fullScreen(component: Component)
    case scrollable(components: [Component])
    case navigateImmediately(navigationViewModel: NavigationViewModel)
}
