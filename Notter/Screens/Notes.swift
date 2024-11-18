//
//  Notes.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import Foundation
import SwiftUI
import SwiftData

struct Notes: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var notes: [Note]
    
    @Environment(Router.self) var router
    @Environment(Modal<AnyView>.self) var modal
    
    @Bindable var noteEditVM = NoteEditVM()
    
    @State var showMenu: Bool = false
    @State var isEditing: Bool = false
    @State var isAdding: Bool = false
    @State var newNoteContent: String = ""
    @State var sortByDateCreated: Bool = true
    @State var clusterings: [String] = []
    
    @State var scrollPositionY: CGFloat = 0
    @State var progress: CGFloat = 0
    
    @State var dimmingworker: DispatchWorkItem?
    
    var friend: Friend
    
    init(friend: Friend) {
        self.friend = friend
        let owner = friend.uuid
        _notes = Query(filter: #Predicate {
            $0.ofWhom == owner
        })
        noteEditVM.updateClustering = self.doUpdateClustering
    }
    
    var body: some View {
        ZStack{
            
            ScrollView(.vertical) {
                
                VStack(spacing: 16) {
                    
                    stickyHeader
                        .padding(.horizontal, 16 - (24 * progress))
                        .zIndex(1)
                        .if(scrollPositionY <= -120){
                            $0.offset(y: -scrollPositionY - 120)
                        }
                        .shadow(radius:4, x: 4, y: 2)
                    
                    
                    VStack(spacing: 16) {
                        
                        ForEach(clusterings, id:\.self){ date in
                            let notesOfDate: [Note] = sortByDateCreated ? notes.filter{ $0.dateCreated == date} :  notes.filter{ $0.dateModified == date}
                            NotesSectionView(notes: notesOfDate, color: friend.color, displayDate: date).environment(noteEditVM)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                    
                }
                .background(
                    
                    GeometryReader { geometry in
                        Color(.clear)
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    }
                )
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    self.scrollPositionY = value.y
                    self.progress = max(min(value.y / -120,1), 0)
                }
                
                
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "scroll")
            .shadow(radius:4, x: 5, y: 5)
            
            if(noteEditVM.isEditing || isAdding){
                Color("\(friend.color)-secondary").opacity(0.45).ignoresSafeArea()
                    .onTapGesture {
                        if noteEditVM.isEditing, let noteToEdit = noteEditVM.noteToEdit {
                            editNote(note: noteToEdit)
                        }else{
                            addNote()
                        }
                        
                        noteEditVM.isEditing = false
                        isAdding = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    }
                
                AddOrEditNoteView(color: friend.color, content: (noteEditVM.isEditing ? $noteEditVM.newNoteContent : $newNoteContent), saveAction: {})
                    .padding()
                    .transition(.move(edge: .top))
            }
            
            fabs
            
        }
        .onAppear{
            self.clusterings = updateClusterings()
        }
        .background(Color(friend.color).ignoresSafeArea())
        .toolbar(.hidden)
    }
    
    var stickyHeader: some View {
        ZStack(alignment: .topTrailing){
            
            HStack{
                
                AvatarView(avatar: friend.avatar, avatarImage: friend.avatarImage, viewable: false, scale: friend.avatarScale ?? 1.0, offset: CGSize(width: friend.avatarOffsetX ?? .zero, height: friend.avatarOffsetY ?? .zero), color: friend.color)
                    .scaleEffect(x: 1 - (0.75 * progress), y: 1 - (0.75 * progress), anchor: .bottomLeading)
                    .padding(.leading, 8 * progress)
                    .offset(y: 8 * progress)
                    .onTapGesture {
                        modal.openModal(with: AnyView(
                            EditAvatarView(friend: friend, finishEdit: {modal.closeModal()})
                        ))
                    }
                
                Spacer()
                
                VStack(spacing: 6){
                    Text(friend.name)
                        .font(.custom("JacquesFrancoisShadow-Regular", size: 28))
                        .scaleEffect(x: 1 - (0.3 * progress), y: 1 - (0.3 * progress), anchor: .top)
                        .offset(x: UIScreen.width * 0.2 * progress, y: 92 * progress)
                    
                    
                    if(progress < 0.5){
                        VStack (spacing: 4){
                            if(friend.mbti != "") {
                                Text(friend.mbti)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("\(friend.color)-tertiary"))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .overlay(Capsule().fill(.clear).stroke(Color("\(friend.color)-tertiary"), lineWidth: 1))
                            }else{
                                Text("")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                            }
                            
                            Text(friend.birthday)
                                .font(.custom("JacquesFrancoisShadow-Regular", size: 28))
                        }
                        .opacity(1.0 - (2.0 * progress))
                        
                    }else{
                        VStack (spacing: 4){
                            if(friend.mbti != "") {
                                Text(friend.mbti)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("\(friend.color)-tertiary"))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .overlay(Capsule().fill(.clear).stroke(Color("\(friend.color)-tertiary"), lineWidth: 1))
                            }else{
                                Text("")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                            }
                            
                            Text(friend.birthday)
                                .font(.custom("JacquesFrancoisShadow-Regular", size: 28))
                        }
                        .opacity(0)
                    }
                }
                .foregroundStyle(.white)
                
                Spacer()
                
            }
            .padding()
            .background(Color("\(friend.color)-secondary"))
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 16 - (16 * progress),
                bottomLeadingRadius: 16 - (16 * progress),
                bottomTrailingRadius: 16 - (16 * progress),
                topTrailingRadius: 0
            ))
            
            Image(getZodiacSign(from: friend.birthday))
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 8)
                .padding(.horizontal, 8)
                .opacity(1.0 - (2.0 * progress))
            
        }
        .onLongPressGesture{
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            modal.openModal(with: AnyView(
                FriendActionsView(friend: friend, editFriend: editFriend(friend:), deleteFriend: deleteFriend)
            ))
        }
    }
    
    @ViewBuilder
    var fabs: some View{
        
        if(!isAdding && !noteEditVM.isEditing){
            
            FabView(color: "\(friend.color)-secondary", trailing: true){
                withAnimation{
                    isAdding = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            
            
            FabView(color: "\(friend.color)-secondary", systemIcon: "arrow.left", leading: true){
                
                if showMenu {
                    router.navigateBack()
                }else{
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                
                withAnimation{
                    showMenu = true
                }
                
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//                    withAnimation{
//                        showMenu = false
//                    }
//                }
                
                let worker = DispatchWorkItem {
                    withAnimation{
                        showMenu = false
                    }
                }
                
                dimmingworker = worker

                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: worker)
            }
            .if(!showMenu){
                $0.opacity(0.1)
            }
            
        }else if(isAdding){
            
            // Confirm add note button
            FabView(color: "\(friend.color)", systemIcon: "checkmark",trailing: true){
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                isAdding = false
                
                addNote()
            }
            .padding(.bottom, 16)
            
        }else{
            
            // Confirm edit note button
            FabView(color: "\(friend.color)", systemIcon: "checkmark",trailing: true){
                
                if let noteToEdit = noteEditVM.noteToEdit{
                    editNote(note: noteToEdit)
                }
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                noteEditVM.isEditing = false
            }
            .padding(.bottom, 16)
            
        }
        
        if showMenu{
            
            let sortText = sortByDateCreated ? "By create date" : "By edit date"
            SortToggleView(color: "\(friend.color)-secondary", sortText: sortText, action:{
                
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                
                sortByDateCreated.toggle()
                self.clusterings = updateClusterings()
                
                dimmingworker?.cancel()
                
                let worker = DispatchWorkItem {
                    withAnimation{
                        showMenu = false
                    }
                }
                
                dimmingworker = worker

                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: worker)
                
            })
        }
    }
    
    func addNote(){
        if(newNoteContent != ""){
            let newNote = Note(content: newNoteContent, ofWhom: friend.uuid)
            modelContext.insert(newNote)
            newNoteContent = ""
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.clusterings = updateClusterings()
        }
    }
    
    func openNoteEditor(content: String){
        noteEditVM.isEditing = true
    }
    
    func editNote(note: Note){
        newNoteContent = ""
        
        if(noteEditVM.newNoteContent == ""){
            deleteNote(note: note)
        }else{
            
            note.content = noteEditVM.newNoteContent
            note.dateModified = getCurrentLocalDate()
        }
        self.clusterings = updateClusterings()
    }
    
    func deleteNote(note: Note){
        Task{
            modelContext.delete(note)
            self.doUpdateClustering()
        }
        newNoteContent = ""
        
    }
    
    func updateClusterings() -> [String]{
        var tempClusterings: [String] = []
        
        if (sortByDateCreated){
            for note in notes {
                if (!tempClusterings.contains(note.dateCreated)){
                    tempClusterings.append(note.dateCreated)
                }
            }
        }else{
            for note in notes {
                if (!tempClusterings.contains(note.dateModified)){
                    tempClusterings.append(note.dateModified)
                }
            }
        }
        
        tempClusterings = tempClusterings.sorted(by: {$0 > $1})
        
        return tempClusterings
    }
    
    func doUpdateClustering(){
        self.clusterings = updateClusterings();
        
    }
    
    func editFriend(friend: Friend){
        router.navigateTo(.EditFriend(friend))
        modal.closeModal()
    }
    
    func deleteFriend(friend: Friend){
        modal.closeModal()
        router.navigateBack()
        withAnimation{
            modelContext.delete(friend)
        }
        
        Task{
            let friendID = friend.uuid
            let notesToDelete = try modelContext.fetch(FetchDescriptor<Note>(predicate: #Predicate<Note> { $0.ofWhom == friendID}))
            for note in notesToDelete {
                modelContext.delete(note)
            }
        }
    }
    
}

@Observable
class NoteEditVM {
    var noteToEdit: Note?
    var isEditing: Bool = false
    var newNoteContent = ""
    
    var updateClustering = {}
    
    func changeNoteToEdit(note: Note){
        noteToEdit = note
        isEditing = true
        newNoteContent = note.content
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

#Preview {
    Notes(friend: Friend(name: "Raj", avatar: "1", birthday: "1998-04-01", mbti: "", color: "tone1")).modelContainer(for: [Friend.self, Note.self], inMemory: true).environment(Router()).environment(Modal(modalContent: AnyView(Text(""))))
}
