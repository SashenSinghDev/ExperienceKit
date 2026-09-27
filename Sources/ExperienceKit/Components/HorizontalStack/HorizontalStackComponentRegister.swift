import Foundation
import SwiftUI

// sourcery: register
final class HorizontalStackComponentRegister: ComponentRegister {
    var contentType: String {
        "horizontalstack"
    }

    var propertiesType: Properties.Type {
        HorizontalStackProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(HorizontalStackViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(HorizontalStackView(any: viewModel))
    }
}
