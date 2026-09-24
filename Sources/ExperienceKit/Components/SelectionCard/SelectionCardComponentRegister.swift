//
//  SelectionCardComponentRegister.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation
import SwiftUI

// sourcery: register
final class SelectionCardComponentRegister: ComponentRegister {

    var contentType: String {
        "selectioncard"
    }

    var propertiesType: Properties.Type {
        SelectionCardProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(SelectionCardViewModel(any: component.properties,
                                                      dependency: dependency,
                                                      id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(SelectionCardView(any: viewModel))
    }
}
