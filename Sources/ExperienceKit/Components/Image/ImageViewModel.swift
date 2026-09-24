import Foundation

public final class ImageViewModel: ComponentViewModel, ObservableObject {
    public typealias Dependencies = EmptyDependency

    public let id: UUID
    public let uri: String
    public let bundle: String
    public let width: Double?
    public let height: Double?

    public init(properties: ImageProperties,
                dependency: Dependencies,
                id: UUID) {
        self.id = id
        self.uri = properties.uri
        self.bundle = properties.bundle
        self.width = properties.width
        self.height = properties.height
    }
}
