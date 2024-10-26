//
//  SecondaryButtonStyle.swift
//
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation
import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.body.bold())
            .background(.white)
            .foregroundStyle(.black)
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
        Text("Log In")
            .frame(maxWidth: .infinity)
    })
    .buttonStyle(SecondaryButtonStyle())
    .padding(.horizontal, 16)
}
