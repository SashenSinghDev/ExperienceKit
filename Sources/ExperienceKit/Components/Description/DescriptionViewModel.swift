//
//  DescriptionViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 01/01/2025.
//

import Foundation
import SwiftUI

public final class DescriptionViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let title: String
    let subtitle: String
    let style: DescriptionProperties.Style

    public init(properties: DescriptionProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
        self.subtitle = properties.subtitle
        self.style = properties.style
    }
}
