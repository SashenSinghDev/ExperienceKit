//
//  SelectionCardViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation
import SwiftUI

public final class SelectionCardViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = HasExperiencePresenterNotifier & HasExperienceSelectionStateStore

    public let id: UUID
    let title: String
    let subtitle: String
    let value: String
    let badgeText: String?
    let selectionId: String
    let selectionGroupId: String?
    let selectionMode: SelectionCardProperties.SelectionMode
    let navigationViewModel: NavigationViewModel?
    private let experiencePresenterNotifier: ExperiencePresenterNotifier
    private let experienceSelectionStateStore: ExperienceSelectionStateStore?
    @Published public var isSelected: Bool
    private static var selectionGroups: [String: [WeakSelectionCardViewModelReference]] = [:]

    public init(properties: SelectionCardProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.subtitle = properties.subtitle
        self.value = properties.value
        self.badgeText = properties.badgeText
        self.selectionId = properties.selectionId ?? id.uuidString
        self.selectionGroupId = properties.selectionGroupId
        self.selectionMode = properties.selectionMode
        self.isSelected = properties.isSelected

        if let navigationProperties = properties.navigation {
            self.navigationViewModel = .init(navigationType: navigationProperties.navigationType,
                                             deferredLoadingWorkId: navigationProperties.deferredLoadingWorkId,
                                             experienceViewModel: navigationProperties.experienceViewModel)
        } else {
            self.navigationViewModel = nil
        }

        self.experiencePresenterNotifier = dependency.experiencePresenterNotifier
        self.experienceSelectionStateStore = dependency.experienceSelectionStateStore
        registerSelectionGroupIfNeeded()
        registerInitialSelectionIfNeeded()
    }

    // The initial selection state comes from properties. Tapping updates the
    // local published state immediately, then forwards navigation if provided.
    func select() {
        updateSelectionState()

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

    private func registerInitialSelectionIfNeeded() {
        guard isSelected else { return }

        if let selectionGroupId {
            switch selectionMode {
            case .single:
                experienceSelectionStateStore?.setSelectedValue(selectionId, for: selectionGroupId)
            case .multiple:
                experienceSelectionStateStore?.addSelectedValue(selectionId, for: selectionGroupId)
            }
        } else {
            experienceSelectionStateStore?.setSelectedValue(selectionId, for: id.uuidString)
        }
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
            experienceSelectionStateStore?.setSelectedValue(selectionId, for: selectionGroupId)
        case .multiple:
            toggleMultipleSelection()
            if isSelected {
                experienceSelectionStateStore?.addSelectedValue(selectionId, for: selectionGroupId)
            } else {
                experienceSelectionStateStore?.removeSelectedValue(selectionId, for: selectionGroupId)
            }
        }
    }

    private func updateStandaloneSelectionState() {
        switch selectionMode {
        case .single:
            isSelected = true
            experienceSelectionStateStore?.setSelectedValue(selectionId, for: id.uuidString)
        case .multiple:
            isSelected.toggle()
            if isSelected {
                experienceSelectionStateStore?.addSelectedValue(selectionId, for: id.uuidString)
            } else {
                experienceSelectionStateStore?.removeSelectedValue(selectionId, for: id.uuidString)
            }
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
