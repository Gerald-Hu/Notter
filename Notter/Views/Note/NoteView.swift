//
//  NoteView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

struct NoteView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(NoteEditVM.self) var noteEditVM
    @Environment(Modal<AnyView>.self) var modal
    
    var note: Note = Note(content: "Jordina Enjoys Splatoon 3, and her favorite character is DJ Octavio.", ofWhom: "")
    
    var expanded = false
    
    var body: some View {
        
        VStack{
            
            HStack(spacing: 0) {
                Text(note.content)
                    .font(.custom("JacquesFrancois-Regular", size: 16))
                    .lineSpacing(4)
                Spacer()
            }
            .padding(.leading, 12)
            .padding(.trailing, 8)
            .padding(.vertical, 8)
            .padding(.top, 2)
            
            if(!expanded){
                Spacer()
            }
            
        }
        .background(.white)
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 16,
            bottomLeadingRadius: 16,
            bottomTrailingRadius: 16,
            topTrailingRadius: 0
        ))
        .onTapGesture {
            noteEditVM.changeNoteToEdit(note: note)
        }
        .onLongPressGesture{
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            modal.openModal(with: AnyView(NoteActionsView(note: note, deleteNote: deleteNote)))
        }
        
    }
    
    func deleteNote(){
        modal.closeModal()
        modelContext.delete(note)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            noteEditVM.updateClustering()
        }
    }
}

#Preview {
    NoteView().environment(NoteEditVM()).environment(Modal(modalContent: AnyView(Text("")))).modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
