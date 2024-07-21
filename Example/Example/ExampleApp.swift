//
//  ExampleApp.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import SwiftUI

@main
struct ExampleApp: App {

    private let dependancyContainer: DependancyContainer

    init() {
        let dependancyServiceManager = DependancyServiceManager()
        dependancyContainer = DependancyContainer(dependencies: dependancyServiceManager)
    }

    var body: some Scene {
        WindowGroup {
            dependancyContainer.makeMainView()
        }
    }
}
