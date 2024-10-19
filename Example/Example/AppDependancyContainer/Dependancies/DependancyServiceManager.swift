//
//  DependancyServiceManager.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import ExperienceKit

final class DependancyServiceManager {
    init() {
    }
}

extension DependancyServiceManager: HasEmptyDependancy {}

// Dependancy would be part of the core
public protocol HasEmptyDependancy {}
