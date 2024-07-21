//
//  File.swift
//  
//
//  Created by Sashen Singh on 08/06/2024.
//

import Foundation

public protocol ExperienceScene: AnyObject {
    func performUpdate(_ update: Experience.Update)
}
