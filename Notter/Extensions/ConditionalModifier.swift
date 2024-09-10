//
//  ConditionalModifier.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
