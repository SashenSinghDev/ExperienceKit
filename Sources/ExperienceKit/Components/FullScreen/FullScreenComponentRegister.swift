import Foundation
import SwiftUI

// sourcery: register
final class FullScreenComponentRegister: ComponentRegister {
    var contentType: String {
        "fullscreen"
    }

    var propertiesType: Properties.Type {
        FullScreenProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(FullScreenViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(FullScreenView(any: viewModel))
    }
}
