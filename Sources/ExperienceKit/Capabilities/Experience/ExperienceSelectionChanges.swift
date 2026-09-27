//
//  ExperienceSelectionChanges.swift
//  ExperienceKit
//
//  Created by Claude on 27/09/2026.
//

import Combine

/// Lets a component react when another component on the same screen writes a
/// selection value, e.g. a validation message clearing as the user fills a field.
public protocol HasExperienceSelectionChanges {
    /// Emits the selection key each time a component writes a value for it.
    var experienceSelectionChanges: AnyPublisher<String, Never> { get }
}

/// Wraps the app-owned store so every component write is also published.
/// Reads and writes are forwarded unchanged, so the app keeps owning the state.
final class ObservedExperienceSelectionStateStore: ExperienceSelectionStateStore {
    private let base: ExperienceSelectionStateStore
    private let changesSubject = PassthroughSubject<String, Never>()

    var changes: AnyPublisher<String, Never> {
        changesSubject.eraseToAnyPublisher()
    }

    init(base: ExperienceSelectionStateStore) {
        self.base = base
    }

    func setSelectedValue(_ value: String, for key: String) {
        base.setSelectedValue(value, for: key)
        changesSubject.send(key)
    }

    func addSelectedValue(_ value: String, for key: String) {
        base.addSelectedValue(value, for: key)
        changesSubject.send(key)
    }

    func removeSelectedValue(_ value: String, for key: String) {
        base.removeSelectedValue(value, for: key)
        changesSubject.send(key)
    }

    func selectedValues(for key: String) -> [String] {
        base.selectedValues(for: key)
    }
}
