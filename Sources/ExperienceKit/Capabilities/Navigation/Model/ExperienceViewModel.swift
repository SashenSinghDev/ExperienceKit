//
//  ExperienceViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

import Foundation

public struct ExperienceViewModel: Codable {
    public struct SearchBar: Codable {
        public let placeholder: String

        public init(placeholder: String) {
            self.placeholder = placeholder
        }
    }
    
    public struct NavigationBar: Codable {
        public enum DisplayMode: Codable {
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

    public let searchBar: SearchBar?
    public let navigationBar: NavigationBar?

    public init(searchBar: SearchBar?,
                navigationBar: NavigationBar?) {
        self.navigationBar = navigationBar
        self.searchBar = searchBar
    }
}
