import Foundation

public final class ContainerViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = ExperienceDependency
    
    public enum VerticalSpacing {
        case small
        case medium
        case large

        var value: CGFloat {
            switch self {
            case .small: return .spacing.small
            case .medium: return .spacing.medium
            case .large: return .spacing.large
            }
        }
    }

    public let id: UUID
    private let component: Component
    let anyComponentViewModel: AnyComponentViewModel
    let viewProvider: ViewProvider
    let verticalSpacing: VerticalSpacing

    public init(properties: ContainerProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.component = properties.component
        self.anyComponentViewModel = dependency.viewModelProvider.viewModel(for: self.component,
                                                                            dependency: dependency)
        self.viewProvider = dependency.viewProvider
        self.verticalSpacing = properties.verticalSpacing.toVerticalSpacing
    }
}

private extension ContainerProperties.VerticalSpacing {
    var toVerticalSpacing: ContainerViewModel.VerticalSpacing {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}
