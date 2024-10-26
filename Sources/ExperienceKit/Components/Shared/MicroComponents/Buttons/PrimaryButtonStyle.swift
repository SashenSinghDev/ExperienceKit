//
//  PrimaryButtonStyle.swift
//
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.body.bold())
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)
//            .background(Color.black
//                             .opacity(0.25)
//                             .shadow(color: .black, radius: 0, x: 4, y: 8)
//                             .blur(radius: 24, opaque: false))
    }
}

#Preview {
    Button(action: {
    }, label: {
        Text("Get Started")
            .frame(maxWidth: .infinity)
    })
    .buttonStyle(PrimaryButtonStyle())
    .padding(.horizontal, 16)
}
