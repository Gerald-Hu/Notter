//
//  NoteCollapsedView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

struct NotesCollapsedView: View {
    
    var notes: [Note] = []
    
    @Binding var expanded: Bool
    
    var body: some View {
        
        GeometryReader{ proxy in
            
            HStack(alignment: .top, spacing: 16){
                
                if(notes.count > 0){
                    NoteView(note: notes[0])
                        .frame(height: proxy.size.height)
                }
                
                if(notes.count > 1){
                    
                    VStack(alignment: .leading, spacing: 8){
                        
                        NoteView(note: notes[1])
                            .frame(height: proxy.size.height - 28 - 8)
                        
                        if(notes.count == 2){
                            Spacer()
                        }
            
                        if(notes.count > 2){
                            ZStack(alignment: .center){
                                Rectangle().fill(.white)
                                    .clipShape(UnevenRoundedRectangle(
                                        topLeadingRadius: 16,
                                        bottomLeadingRadius: 16,
                                        bottomTrailingRadius: 16,
                                        topTrailingRadius: 0
                                    ))
                                
                                Image(systemName: "ellipsis")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                
                            }.frame(width: proxy.size.width * 0.42, height: 28)
                                .onTapGesture {
                                    expanded = true
                                }
                        }
                        
                        
                    }
                    .frame(height: proxy.size.height)
                    
                }
            }

            
        }
        .padding(.bottom, 12)
        .if(notes.count != 1){
            $0.frame(height: 160)
        }
        .if(notes.count == 1){
            $0.frame(height: 100)
        }
    }
}

#Preview {
    NotesSectionView(expanded: false)
}
