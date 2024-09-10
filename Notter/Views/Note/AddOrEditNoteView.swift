//
//  AddOrEditNoteView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

struct AddOrEditNoteView: View {
    
    var color = "tone1"
    
    @Binding var content: String
    
    @FocusState private var isFocused
    
    let saveAction: () -> Void
    
    var body: some View {
            
            VStack {
                
                TextEditor(text: $content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(height: UIScreen.height * 0.3 - 32)
                    .font(.custom("JacquesFrancois-Regular", size: 16))
                    .lineSpacing(2.0)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .focused($isFocused)
                
            }
            .padding(.horizontal, 12)
            .frame(height: UIScreen.height * 0.3)
            .background(Color("\(color)-tertiary"))
            .clipShape(.rect(
                topLeadingRadius: 16,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16,
                topTrailingRadius: 0
            ))
            .shadow(radius: 10)
            .offset(y: -16)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isFocused = true
                }
            }
        
    }
    
}

#Preview {
    AddOrEditNoteView(content: .constant(""), saveAction: {})
}
