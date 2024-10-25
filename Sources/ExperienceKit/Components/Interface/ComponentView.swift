//
//  ComponentView.swift
//
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation
import SwiftUI

protocol ComponentView: View, Equatable {
    associatedtype ConcreteViewModel: ComponentViewModel

    init(viewModel: ConcreteViewModel)
}

extension ComponentView {
    init(any: Any) {
        self.init(viewModel: any as! ConcreteViewModel)
    }
}
