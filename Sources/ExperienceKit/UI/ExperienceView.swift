//
//  ExperienceView.swift
//  
//
//  Created by Sashen Singh on 31/05/2024.
//

import SwiftUI

public struct ExperienceView: View {

    @ObservedObject var observer: ExperienceObservable
    private let viewProvider: ViewProvider

    public init(observer: ExperienceObservable,
                viewProvider: ViewProvider) {
        self.observer = observer
        self.viewProvider = viewProvider
    }

    public var body: some View {
        ScrollView {
            VStack {
                ForEach(observer.anyViewModel.components) { component in
                    makeView(from: component)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                observer.performAction(.load)
            }
        }
    }

    @ViewBuilder
    private func makeView(from component: AnyComponentViewModel) -> some View {
        viewProvider.view(for: component)
    }
}
