//
//  AnyComponentView.swift
//
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

protocol ComponentView: View {
    associatedtype ConcreteViewModel: ComponentViewModel

    init(viewModel: ConcreteViewModel, presenter: ExperiencePresenter)
}

extension ComponentView {
    init(any: Any, presenter: ExperiencePresenter) {
        self.init(viewModel: any as! ConcreteViewModel, presenter: presenter)
    }
}

struct AnyContentView: ComponentView {
    private var viewImpl: () -> AnyView

    var body: some View {
        return viewImpl()
    }

    init(viewModel: AnyComponentViewModel, presenter: ExperiencePresenter) {
        fatalError("Not to be used")
    }

    typealias ConcreteViewModel = AnyComponentViewModel

    init<I: ComponentView>(_ contentView: I) {
        self.viewImpl = {
            return AnyView(contentView.body)
        }
    }
}
