import Foundation

public final class ImageViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    public let uri: String
    public let bundle: String

    public init(properties: ImageProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.uri = properties.uri
        self.bundle = properties.bundle
    }
}
