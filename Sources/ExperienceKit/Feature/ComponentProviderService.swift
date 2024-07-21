//
//  ComponentProviderService.swift
//
//
//  Created by Sashen Singh on 08/06/2024.
//

import Foundation

public protocol ComponentProviderService {
    func load(completion: @escaping ([Component]) -> Void)
}

public protocol HasComponentProviderService {
    var componentProviderService: ComponentProviderService { get }
}
