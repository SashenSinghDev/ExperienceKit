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

    public struct SearchBar {
        public let placeholder: String

        public init(placeholder: String) {
            self.placeholder = placeholder
        }
    }

    public let title: String
    public let displayMode: DisplayMode
    public let searchBar: SearchBar?

    public init(title: String,
                displayMode: DisplayMode,
                searchBar: SearchBar?) {
        self.title = title
        self.displayMode = displayMode
        self.searchBar = searchBar
    }
}
