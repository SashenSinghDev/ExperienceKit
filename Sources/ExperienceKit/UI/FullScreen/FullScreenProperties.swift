import Foundation

public struct FullScreenProperties {
    public let image: ExperienceImage?
    public let topComponents: [Component]
    public let middleComponents: [Component]
    public let bottomComponents: [Component]

    public init(image: ExperienceImage?,
                topComponents: [Component],
                middleComponents: [Component],
                bottomComponents: [Component]) {
        self.image = image
        self.topComponents = topComponents
        self.middleComponents = middleComponents
        self.bottomComponents = bottomComponents
    }
}

extension FullScreenProperties: Codable {}
