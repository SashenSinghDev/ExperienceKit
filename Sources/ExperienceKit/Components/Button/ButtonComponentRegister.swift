//
//  ButtonComponentRegister.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 16/02/2025.
//

import Foundation
import SwiftUI

final class ButtonComponentRegister: ComponentRegister {

    var contentType: String {
        "button"
    }

    var propertiesType: Properties.Type {
        ButtonProperties.self
    }

    func viewModel(from component: Component, dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(ButtonViewModel(any: component.properties,
                                              dependency: dependency,
                                               id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(ButtonView(any: viewModel))
    }
}
