import Foundation

public final class SpacerViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    
    public enum Size: Codable {
        case small
        case medium
        case large
    }
    
    let size: Size

    public init(properties: SpacerProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.size = properties.size.toSize
    }
}

private extension SpacerProperties.Size {
    var toSize: SpacerViewModel.Size {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}
