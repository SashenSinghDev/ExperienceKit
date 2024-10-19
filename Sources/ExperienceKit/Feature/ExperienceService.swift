//
//  ComponentProviderService.swift
//
//
//  Created by Sashen Singh on 08/06/2024.
//

import Foundation

public protocol ExperienceService {
    func load(completion: @escaping ([Component]) -> Void)
}
