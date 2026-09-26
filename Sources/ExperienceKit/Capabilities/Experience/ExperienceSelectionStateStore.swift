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
    var experienceSelectionStateStore: ExperienceSelectionStateStore { get }
}

public protocol ExperienceSelectionStateConsuming: AnyObject {
    var experienceSelectionStateStore: ExperienceSelectionStateStore? { get set }
}

public final class DefaultExperienceSelectionStateStore: ExperienceSelectionStateStore {
    private var selectedValuesByKey: [String: [String]] = [:]

    public init() {}

    public func setSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key] = [value]
    }

    public func addSelectedValue(_ value: String, for key: String) {
        var selectedValues = selectedValuesByKey[key, default: []]
        guard !selectedValues.contains(value) else {
            return
        }

        selectedValues.append(value)
        selectedValuesByKey[key] = selectedValues
    }

    public func removeSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key] = selectedValuesByKey[key, default: []].filter { $0 != value }
    }

    public func selectedValues(for key: String) -> [String] {
        selectedValuesByKey[key, default: []]
    }
}
