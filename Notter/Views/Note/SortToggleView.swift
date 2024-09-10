//
//  SortToggleView.swift
//  Notter
//
//  Created by Gerald on 2024-08-15.
//

import SwiftUI

struct SortToggleView: View {
    
    var color: String = "tone1"
    var sortText: String = ""
    
    let action: () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            
            HStack{
                
                Button(action: action) {
                    Text(sortText)
                        .foregroundStyle(.white)
                }
                .frame(width: 200, height: 60)
                .background(Color(color))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4, x: 0, y: 4)

            }
            .padding(.horizontal, 24)
            
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    SortToggleView(action: {})
}
