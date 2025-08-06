//
//  SeparatorComponentRegister.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 25/07/2025.
//

import Foundation
import SwiftUI

// sourcery: register
final class SeparatorComponentRegister: ComponentRegister {

    var contentType: String {
        "separator"
    }

    var propertiesType: Properties.Type {
        SeparatorProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(SeparatorViewModel(any: component.properties,
                                                 dependency: dependency,
                                                 id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(SeparatorView(any: viewModel))
    }
}
