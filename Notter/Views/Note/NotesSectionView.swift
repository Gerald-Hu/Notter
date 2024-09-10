//
//  NoteSectionView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

struct NotesSectionView: View {
    
    var notes: [Note] = []
    
    var color: String = "tone1-tertiary"
    var displayDate: String = "1970-08-01"
    
    @State var expanded = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack(spacing: 12){
                
                HStack{
                    Text(displayDate)
                        .font(.custom("JacquesFrancois-Regular", size: 20))
                        .padding(.bottom, 4)
                        .padding(.horizontal, 8)
                        .frame(height: 36)
                    Spacer()
                }
                .background(.white)
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16,
                    topTrailingRadius: 16
                ))
                
                
                if(expanded){
                    NotesExpandedView(notes: notes)
                        .padding(.horizontal, 12)
                }else{
                    NotesCollapsedView(notes: notes, expanded: $expanded)
                        .padding(.horizontal, 12)
                }
                
                
                
            }
            .if(expanded){
                $0.padding(.bottom, 24)
            }
            .background(Color("\(color)-tertiary"))
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16,
                topTrailingRadius: 16
            ))
            
            if(notes.count > 1){
                VStack{
                    Image("dots")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(.bottom, 10)
                }
                .onTapGesture {
                    expanded.toggle()
                }
            }
        }
    }
}

#Preview {
    VStack{
        Spacer()
        NotesSectionView()
        Spacer()
    }
    .background(.tone1)
}
