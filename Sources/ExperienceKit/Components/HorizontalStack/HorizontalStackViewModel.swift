import Foundation

public final class HorizontalStackViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = ExperienceDependency

    public let id: UUID
    let children: [AnyComponentViewModel]
    let viewProvider: ViewProvider
    let spacing: CGFloat
    let alignment: HorizontalStackProperties.Alignment
    let distribution: HorizontalStackProperties.Distribution

    public init(properties: HorizontalStackProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        // Children share this session's dependency, so components such as
        // TextField keep writing to the injected selection state store.
        self.children = properties.components.map {
            dependency.viewModelProvider.viewModel(for: $0, dependency: dependency)
        }
        self.viewProvider = dependency.viewProvider
        self.spacing = properties.spacing.value
        self.alignment = properties.alignment
        self.distribution = properties.distribution
    }
}

private extension HorizontalStackProperties.Spacing {
    var value: CGFloat {
        switch self {
        case .none: return .spacing.none
        case .small: return .spacing.small
        case .medium: return .spacing.medium
        case .large: return .spacing.large
        }
    }
}
