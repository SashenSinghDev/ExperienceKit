//
//  NavigationProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

public struct NavigationProperties: Codable {
    public let navigationType: NavigationType
    public let deferredLoadingWorkId: AnyDeferredWorkID?
    public let navigationBarModel: NavigationBarModel?

    public init(navigationType: NavigationType,
                deferredLoadingWorkId: (any DeferredWorkID)?,
                navigationBarModel: NavigationBarModel?) {
        self.navigationType = navigationType
        self.deferredLoadingWorkId = deferredLoadingWorkId.map { AnyDeferredWorkID(rawValue: $0.rawValue) }
        self.navigationBarModel = navigationBarModel
    }

    private enum CodingKeys: String, CodingKey {
        case navigationType
        case deferredLoadingWorkId
        case navigationBarModel
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        navigationType = try container.decode(NavigationType.self, forKey: .navigationType)
        deferredLoadingWorkId = try container.decodeIfPresent(String.self, forKey: .deferredLoadingWorkId)
            .map(AnyDeferredWorkID.init(rawValue:))
        navigationBarModel = try container.decodeIfPresent(NavigationBarModel.self, forKey: .navigationBarModel)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(navigationType, forKey: .navigationType)
        try container.encodeIfPresent(deferredLoadingWorkId?.rawValue, forKey: .deferredLoadingWorkId)
        try container.encodeIfPresent(navigationBarModel, forKey: .navigationBarModel)
    }
}

public struct AnyDeferredWorkID: DeferredWorkID {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
