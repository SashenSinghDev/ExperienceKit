import Foundation
import SwiftUI

// sourcery: register
final class ImageComponentRegister: ComponentRegister {
    var contentType: String {
        "image"
    }

    var propertiesType: Properties.Type {
        ImageProperties.self
    }

    func viewModel(from component: Component,  dependency: ExperienceDependency) -> AnyComponentViewModel {
        AnyComponentViewModel(ImageViewModel(any: component.properties,
                                                                dependency: dependency,
                                                                id: component.id),
                              contentType: contentType)
    }

    func view(from viewModel: any ComponentViewModel) -> AnyView {
        return AnyView(ImageView(any: viewModel))
    }
}
