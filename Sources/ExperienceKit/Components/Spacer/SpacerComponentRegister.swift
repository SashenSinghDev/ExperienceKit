import Foundation
import SwiftUI

// sourcery: register
final class SpacerComponentRegister: ComponentRegister {
    var contentType: String {
        "spacer"
    }

    var propertiesType: Properties.Type {
        SpacerProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(SpacerViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(SpacerView(any: viewModel))
    }
}
