import Foundation
import SwiftUI

// sourcery: register
final class HorizontalContainerComponentRegister: ComponentRegister {
    var contentType: String {
        "horizontalcontainer"
    }

    var propertiesType: Properties.Type {
        HorizontalContainerProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(HorizontalContainerViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(HorizontalContainerView(any: viewModel))
    }
}
