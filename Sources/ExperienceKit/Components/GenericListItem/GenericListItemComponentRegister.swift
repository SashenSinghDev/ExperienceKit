//
//  GenericListItemComponentRegister.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 12/07/2025.
//

import Foundation
import SwiftUI

final class GenericListItemComponentRegister: ComponentRegister {

    var contentType: String {
        "genericListItem"
    }

    var propertiesType: Properties.Type {
        GenericListItemProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(GenericListItemViewModel(any: component.properties,
                                                       dependency: dependency,
                                                       id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(GenericListItemView(any: viewModel))
    }
}
