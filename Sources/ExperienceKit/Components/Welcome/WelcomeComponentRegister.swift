//
//  WelcomeComponentRegister.swift
//  
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation
import SwiftUI

final class WelcomeComponentRegister: ComponentRegister {

    var contentType: String {
        "welcomeComponent"
    }

    var propertiesType: Properties.Type {
        WelcomeProperties.self
    }

    func viewModel(from component: Component) -> AnyComponentViewModel {
        AnyComponentViewModel(WelcomeViewModel(any: component.properties,
                                               id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(WelcomeView(any: viewModel))
    }
}
