//
//  RequiredFieldModifier.swift
//  NewLearnings
//
//  Created by Ibrahim Gedami on 03/05/2025.
//

import SwiftUI

struct RequiredFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.overlay(
            HStack {
                Text("*")
                    .foregroundStyle(.red)
                    .padding(.leading, -10)
                    .padding(.top, -10)
                Spacer()
            }
                .padding(.top, 5), alignment: .topLeading
        )
    }

}

struct EnableFieldModifier: ViewModifier {
    
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content.environment(\.isEnabled, isEnabled)
    }

}
