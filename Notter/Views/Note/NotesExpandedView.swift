//
//  NoteExpandedView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

struct NotesExpandedView: View {
    
    var notes: [Note] = []
    
    var body: some View {
        VStack(spacing: 16){
            
            ForEach(notes, id:\.uuid){
                NoteView(note: $0, expanded: true)
            }
            
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    NotesExpandedView()
}
