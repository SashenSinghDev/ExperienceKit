//
//  SectionTitleViewModel.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation
import SwiftUI

public final class SectionTitleViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    let title: String

    public init(properties: SectionTitleProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.title = properties.title
    }
}
