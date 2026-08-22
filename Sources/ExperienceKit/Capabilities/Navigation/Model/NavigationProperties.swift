//
//  NavigationProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

public struct NavigationProperties: Codable {
    public let navigationType: NavigationType
    public let deferredLoadingWorkId: AnyDeferredWorkID?
    public let additionalProperties: [String: String]?

    public init(navigationType: NavigationType, deferredLoadingWorkId: DeferredWorkID?, additionalProperties: [String: String]?) {
        self.navigationType = navigationType
        self.deferredLoadingWorkId = deferredLoadingWorkId.map { AnyDeferredWorkID(rawValue: $0.rawValue) }
        self.additionalProperties = additionalProperties
    }

    private enum CodingKeys: String, CodingKey {
        case navigationType
        case deferredLoadingWorkId
        case additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        navigationType = try container.decode(NavigationType.self, forKey: .navigationType)
        deferredLoadingWorkId = try container.decodeIfPresent(String.self, forKey: .deferredLoadingWorkId)
            .map(AnyDeferredWorkID.init(rawValue:))
        additionalProperties = try container.decodeIfPresent([String: String].self, forKey: .additionalProperties)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(navigationType, forKey: .navigationType)
        try container.encodeIfPresent(deferredLoadingWorkId?.rawValue, forKey: .deferredLoadingWorkId)
        try container.encodeIfPresent(additionalProperties, forKey: .additionalProperties)
    }
}

public struct AnyDeferredWorkID: DeferredWorkID {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
