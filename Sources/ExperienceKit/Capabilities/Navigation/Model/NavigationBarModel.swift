//
//  NavigationBarViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

import Foundation

public struct NavigationBarModel {
    public enum DisplayMode {
        case automatic
        case inline
        case large
    }

    public let title: String
    public let displayMode: DisplayMode

    public init(title: String, displayMode: DisplayMode) {
        self.title = title
        self.displayMode = displayMode
    }
}
