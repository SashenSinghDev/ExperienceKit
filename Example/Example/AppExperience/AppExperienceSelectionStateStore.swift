//
//  AppExperienceSelectionStateStore.swift
//  Example
//
//  Created by Codex on 26/09/2026.
//

import ExperienceKit
import Foundation

final class AppExperienceSelectionStateStore: ExperienceSelectionStateStore {
    private var selectedValuesByKey: [String: [String]] = [:]

    func setSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key] = [value]
    }

    func addSelectedValue(_ value: String, for key: String) {
        var selectedValues = selectedValuesByKey[key, default: []]
        guard !selectedValues.contains(value) else {
            return
        }

        selectedValues.append(value)
        selectedValuesByKey[key] = selectedValues
    }

    func removeSelectedValue(_ value: String, for key: String) {
        selectedValuesByKey[key] = selectedValuesByKey[key, default: []].filter { $0 != value }
    }

    func selectedValues(for key: String) -> [String] {
        selectedValuesByKey[key, default: []]
    }
}
