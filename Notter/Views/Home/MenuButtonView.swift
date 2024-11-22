//
//  MenuButtonView.swift
//  Notter
//
//  Created by Gerald on 2024-11-21.
//

import SwiftUI

struct MenuButtonView: View {
    var body: some View {
            ZStack {
                // Button background with border
                Circle()
                    .fill(.clear)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1)
                    )
                
                // Menu icon
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
}

#Preview {
    MenuButtonView()
}
