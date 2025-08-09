import Foundation
import SwiftUI

// sourcery: register
final class ContainerComponentRegister: ComponentRegister {
    var contentType: String {
        "container"
    }

    var propertiesType: Properties.Type {
        ContainerProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(ContainerViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(ContainerView(any: viewModel))
    }
}
