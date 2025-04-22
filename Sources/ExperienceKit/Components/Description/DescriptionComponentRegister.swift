//
//  DescriptionComponentRegister.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 01/01/2025.
//

import Foundation
import SwiftUI

final class DescriptionComponentRegister: ComponentRegister {

    var contentType: String {
        "descriptionComponent"
    }

    var propertiesType: Properties.Type {
        DescriptionProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(DescriptionViewModel(any: component.properties,
                                                   dependency: dependency,
                                                   id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(DescriptionView(any: viewModel))
    }
}
