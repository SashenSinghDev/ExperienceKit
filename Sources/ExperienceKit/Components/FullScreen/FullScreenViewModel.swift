import Foundation

public final class FullScreenViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = ExperienceDependency

    enum HorizontalAlignment {
        case leading
        case center
        case trailing
    }

    enum VerticalAlignment {
        case top
        case center
        case bottom
    }

    public let id: UUID
    let image: ExperienceImage?
    let topAnyComponentViewModels: [AnyComponentViewModel]
    let middleAnyComponentViewModels: [AnyComponentViewModel]
    let bottomAnyComponentViewModels: [AnyComponentViewModel]
    let viewProvider: ViewProvider

    public init(properties: FullScreenProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.image = properties.image
        self.topAnyComponentViewModels = properties.topComponents.map { dependency.viewModelProvider.viewModel(for: $0, dependency: dependency) }
        self.middleAnyComponentViewModels = properties.middleComponents.map { dependency.viewModelProvider.viewModel(for: $0, dependency: dependency) }
        self.bottomAnyComponentViewModels = properties.bottomComponents.map { dependency.viewModelProvider.viewModel(for: $0, dependency: dependency) }
        self.viewProvider = dependency.viewProvider
    }
}

