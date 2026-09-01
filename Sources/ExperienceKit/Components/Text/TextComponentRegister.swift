import Foundation
import SwiftUI

// sourcery: register
final class TextComponentRegister: ComponentRegister {
    var contentType: String {
        "text"
    }

    var propertiesType: Properties.Type {
        TextProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(TextViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(TextView(any: viewModel))
    }
}
