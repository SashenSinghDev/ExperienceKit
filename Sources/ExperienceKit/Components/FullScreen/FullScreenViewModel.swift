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
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let topAnyComponentViewModels: [AnyComponentViewModel]
    let middleAnyComponentViewModels: [AnyComponentViewModel]
    let bottomAnyComponentViewModels: [AnyComponentViewModel]
    let viewProvider: ViewProvider

    public init(properties: FullScreenProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.image = properties.image
        self.horizontalAlignment = properties.horizontalAlignment.toHorizontalAlignment
        self.verticalAlignment = properties.verticalAlignment.toVerticalAlignment
        self.topAnyComponentViewModels = properties.topComponents.map { dependency.viewModelProvider.viewModel(for: $0, dependency: dependency) }
        self.middleAnyComponentViewModels = properties.middleComponents.map { dependency.viewModelProvider.viewModel(for: $0, dependency: dependency) }
        self.bottomAnyComponentViewModels = properties.bottomComponents.map { dependency.viewModelProvider.viewModel(for: $0, dependency: dependency) }
        self.viewProvider = dependency.viewProvider
    }
}

private extension FullScreenProperties.HorizontalAlignment {
    var toHorizontalAlignment: FullScreenViewModel.HorizontalAlignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .center:
            return .center
        }
    }
}

private extension FullScreenProperties.VerticalAlignment {
    var toVerticalAlignment: FullScreenViewModel.VerticalAlignment {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .center:
            return .center
        }
    }
}

