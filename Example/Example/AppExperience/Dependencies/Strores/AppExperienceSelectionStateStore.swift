//
//  AppExperienceSelectionStateStore.swift
//  Example
//
//  Created by Codex on 26/09/2026.
//

import Foundation

/// Holds the values a user has selected or entered, keyed by what they describe.
///
/// Interactors write to it from `performDeferredWork` when a component reports a
/// change, and read from it to rebuild a screen or act on earlier answers.
/// ExperienceKit never sees the store.
protocol SelectionStateStore: AnyObject {
    /// Replaces every value held for `key`.
    func setSelectedValues(_ values: [String], for key: String)
    func selectedValues(for key: String) -> [String]
    /// Clears every captured value. Used when a multi-screen flow that shares
    /// this store starts a new run.
    func removeAllSelectedValues()
}

final class AppExperienceSelectionStateStore: SelectionStateStore {
    private var selectedValuesByKey: [String: [String]] = [:]

    func setSelectedValues(_ values: [String], for key: String) {
        selectedValuesByKey[key] = values
    }

    func selectedValues(for key: String) -> [String] {
        selectedValuesByKey[key, default: []]
    }

    func removeAllSelectedValues() {
        selectedValuesByKey.removeAll()
    }
}

extension SelectionStateStore {
    /// Stores `defaultValue` for `key` unless a value is already held, and returns
    /// the value now held.
    ///
    /// Components only report changes, so an interactor seeds the option it
    /// preselects. The default is then captured even if the user never changes it.
    @discardableResult
    func seedSelectedValue(_ defaultValue: String, for key: String) -> String {
        if let selectedValue = selectedValues(for: key).first {
            return selectedValue
        }

        setSelectedValues([defaultValue], for: key)
        return defaultValue
    }
}
