//
//  ContentView.swift
//  Example
//
//  Created by Sashen Singh on 04/07/2024.
//

import SwiftUI
import ExperienceKit

struct ContentView: View {
    private let dependancyContainer: DependancyContainer

    init() {
        let dependancyServiceManager = DependancyServiceManager()
        dependancyContainer = DependancyContainer(dependencies: dependancyServiceManager)
    }

    var body: some View {
        NavigationStack {
            dependancyContainer.makeMainView()
                .navigationDestination(for: ExampleViewModel.self) { viewModel in
                    Text("\(viewModel.publishedAmount)")
                }
                .navigationTitle("ExprienceKit")
        }
    }
}

#Preview {
    ContentView()
}
