import Foundation

// sourcery: component = "progressstepper"
public struct ProgressStepperProperties {
    public let currentStep: Int
    public let totalSteps: Int

    public init(currentStep: Int,
                totalSteps: Int = 3) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }
}

extension ProgressStepperProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ProgressStepperProperties {
        return try properties.decode(ProgressStepperProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension ProgressStepperProperties {
    static var mock: Component {
        Component(contentType: "progressstepper",
                  properties: ProgressStepperProperties(currentStep: 2),
                  id: UUID())
    }
}
#endif
