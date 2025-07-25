//
//  NavigationProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 28/06/2025.
//

public struct NavigationProperties: Codable {    
    public let navigationType: NavigationType
    public let deferredLoadingWorkId: String?
    public let additionalProperties: [String: String]?

    public init(navigationType: NavigationType, deferredLoadingWorkId: String?, additionalProperties: [String: String]?) {
        self.navigationType = navigationType
        self.deferredLoadingWorkId = deferredLoadingWorkId
        self.additionalProperties = additionalProperties
    }
}
