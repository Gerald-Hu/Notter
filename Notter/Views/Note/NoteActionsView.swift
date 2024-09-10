//
//  NoteActionsView.swift
//  Notter
//
//  Created by Gerald on 2024-08-13.
//

import SwiftUI

struct NoteActionsView: View {
    
    var note: Note
    
    var deleteNote: () -> ()
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    Text(note.content)
                    Rectangle().fill(.clear)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .font(.custom("JacquesFrancois-Regular", size: 16))
            .lineSpacing(2.0)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(height: UIScreen.height * 0.3 - 32)
            
            Spacer()
            
            HStack(spacing: 100){
                
                
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 68, height: 68)
                    .background(.gray.opacity(0.15))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        deleteNote()
                    }
                
                
            }
            
            
            Spacer()
        }
        .padding()
        .shadow(radius: 10)
    }
}

#Preview {
    ZStack{
        BackdropBlurView()
        NoteActionsView(note: Note(content: "aaa", ofWhom: ""), deleteNote: {})
    }
}
