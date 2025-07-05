//
//  ExperienceImage.swift
//
//
//  Created by Sashen Singh on 26/10/2024.
//

import Foundation

public struct ExperienceImage: Codable {
    public let uri: String
    public let bundle: String

    public init(uri: String, bundle: String) {
        self.uri = uri
        self.bundle = bundle
    }
}
