//
//  ExperienceSelectionStateStore.swift
//  ExperienceKit
//
//  Created by Codex on 26/09/2026.
//

import Foundation

public protocol ExperienceSelectionStateStore: AnyObject {
    func setSelectedValue(_ value: String, for key: String)
    func addSelectedValue(_ value: String, for key: String)
    func removeSelectedValue(_ value: String, for key: String)
    func selectedValues(for key: String) -> [String]
}

public protocol HasExperienceSelectionStateStore {
    var experienceSelectionStateStore: ExperienceSelectionStateStore? { get }
}
