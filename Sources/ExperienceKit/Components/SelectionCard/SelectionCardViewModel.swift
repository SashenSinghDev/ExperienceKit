//
//  SelectionCardViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation
import SwiftUI

public final class SelectionCardViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperiencePresenterNotifier

    public let id: UUID
    let title: String
    let subtitle: String
    /// `nil` when the card has no trailing value, which selects the
    /// choice-card layout.
    let value: String?
    let badgeText: String?
    let badgeStyle: SelectionCardProperties.BadgeStyle
    let selectionId: String
    let selectionGroupId: String?
    let selectionMode: SelectionCardProperties.SelectionMode
    let navigationViewModel: NavigationViewModel?
    private let onChangeWorkId: AnyDeferredWorkID?
    private let experiencePresenterNotifier: ExperiencePresenterNotifier
    @Published public var isSelected: Bool
    private static var selectionGroups: [String: [WeakSelectionCardViewModelReference]] = [:]

    public init(properties: SelectionCardProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.subtitle = properties.subtitle
        self.value = properties.value.flatMap { $0.isEmpty ? nil : $0 }
        self.badgeText = properties.badgeText.flatMap { $0.isEmpty ? nil : $0 }
        self.badgeStyle = properties.badgeStyle
        self.selectionId = properties.selectionId ?? id.uuidString
        self.selectionGroupId = properties.selectionGroupId
        self.selectionMode = properties.selectionMode
        self.isSelected = properties.isSelected
        self.onChangeWorkId = properties.onChangeWorkId

        if let navigationProperties = properties.navigation {
            self.navigationViewModel = .init(navigationType: navigationProperties.navigationType,
                                             deferredLoadingWorkId: navigationProperties.deferredLoadingWorkId,
                                             experienceViewModel: navigationProperties.experienceViewModel)
        } else {
            self.navigationViewModel = nil
        }

        self.experiencePresenterNotifier = dependency.experiencePresenterNotifier
        registerSelectionGroupIfNeeded()
    }

    // The initial selection state comes from properties. Tapping updates the
    // local published state immediately, reports the change to the interactor,
    // then forwards navigation if provided.
    func select() {
        let previousSelectedValues = selectedValues()
        updateSelectionState()
        notifySelectionChanged(from: previousSelectedValues)

        guard let navigationViewModel else {
            return
        }
        experiencePresenterNotifier.delegate?.navigate(navigationViewModel: navigationViewModel)
    }

    private func registerSelectionGroupIfNeeded() {
        guard let selectionGroupId else { return }

        let existingGroup = Self.selectionGroups[selectionGroupId, default: []]
            .filter { $0.value != nil && $0.value !== self }
        Self.selectionGroups[selectionGroupId] = existingGroup + [WeakSelectionCardViewModelReference(value: self)]
    }

    /// The selected `selectionId`s in this card's group, in the order the cards
    /// were created. A card without a group reports only itself.
    private func selectedValues() -> [String] {
        guard let selectionGroupId else {
            return isSelected ? [selectionId] : []
        }

        var seenSelectionIds = Set<String>()
        return Self.selectionGroups[selectionGroupId, default: []]
            .compactMap { $0.value }
            .filter { $0.isSelected }
            .map { $0.selectionId }
            .filter { seenSelectionIds.insert($0).inserted }
    }

    /// The interactor owns what happens with the selection; the card only reports it.
    private func notifySelectionChanged(from previousSelectedValues: [String]) {
        let currentSelectedValues = selectedValues()

        guard let onChangeWorkId, currentSelectedValues != previousSelectedValues else {
            return
        }
        experiencePresenterNotifier.delegate?.performDeferredWork(workId: onChangeWorkId, values: currentSelectedValues)
    }

    private func updateSelectionState() {
        guard let selectionGroupId else {
            updateStandaloneSelectionState()
            return
        }

        Self.selectionGroups[selectionGroupId] = Self.selectionGroups[selectionGroupId, default: []]
            .filter { $0.value != nil }

        switch selectionMode {
        case .single:
            selectSingleCard(in: selectionGroupId)
        case .multiple:
            toggleMultipleSelection()
        }
    }

    private func updateStandaloneSelectionState() {
        switch selectionMode {
        case .single:
            isSelected = true
        case .multiple:
            isSelected.toggle()
        }
    }

    private func selectSingleCard(in selectionGroupId: String) {
        Self.selectionGroups[selectionGroupId]?.forEach { selectionCardViewModelReference in
            guard let selectionCardViewModel = selectionCardViewModelReference.value else { return }
            selectionCardViewModel.isSelected = selectionCardViewModel.selectionId == selectionId
        }
    }

    private func toggleMultipleSelection() {
        isSelected.toggle()
    }
}

private final class WeakSelectionCardViewModelReference {
    weak var value: SelectionCardViewModel?

    init(value: SelectionCardViewModel) {
        self.value = value
    }
}
