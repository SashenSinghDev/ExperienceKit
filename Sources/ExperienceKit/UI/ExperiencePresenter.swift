//
//  DefaultExperiencePresenter.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation
import SwiftUI

public final class ExperiencePresenter: ObservableObject {

    public enum State {
        case idle
        case loading
        case failed(Error)
        case loadedScrollable([AnyComponentViewModel])
        case loadedFullScreen(AnyComponentViewModel)
    }

    @Published public var state: State = .idle

    private let viewModelProvider: ViewModelProvider
    private let experienceInteractor: ExperienceInteractor

    public init(viewModelProvider: ViewModelProvider,
                experienceInteractor: ExperienceInteractor) {
        self.viewModelProvider = viewModelProvider
        self.experienceInteractor = experienceInteractor
    }

    public func load() {
        self.experienceInteractor.load { [weak self] experienceType in

            guard let self else { return }

            switch experienceType {
            case .fullScreen(let component):
                guard let viewModel = self.viewModelProvider.viewModel(for: component) else {
                    // TODO: Log this instead
                    fatalError("full screen component not supported")
                }
                self.state = .loadedFullScreen(viewModel)
            case .scrollable(let components):
                let viewModels: [AnyComponentViewModel] = components.compactMap {
                    return self.viewModelProvider.viewModel(for: $0)
                }

                self.state = .loadedScrollable(viewModels)
            }
        }
    }
}
