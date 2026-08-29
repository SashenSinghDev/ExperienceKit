//
//  SeparatorViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 25/07/2025.
//

import Foundation
import SwiftUI

public final class SeparatorViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let isFullWidth: Bool

    public init(properties: SeparatorProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.isFullWidth = properties.isFullWidth
    }
}
