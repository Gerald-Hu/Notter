//
//  NameCardView.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI
import SwiftData

struct NameCardView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Environment(Modal<AnyView>.self) var modal
    @Environment(Router.self) var router
    
    var friend: Friend = Friend(name: "Friend", avatar: "2" , birthday: "", mbti: "", color: "tone1")
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                VStack(spacing: 24) {
                    
                    AvatarView(avatar: friend.avatar, avatarImage: friend.avatarImage, scale: friend.avatarScale ?? 1.0, offset: CGSize(width: friend.avatarOffsetX ?? .zero, height: friend.avatarOffsetY ?? .zero), color: friend.color)
                    
                    Text(friend.name)
                        .foregroundStyle(.white)
                        .font(.custom("JacquesFrancoisShadow-Regular", size: 24))
                }
                Spacer()
            }
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(friend.color), Color("\(friend.color)-secondary")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 16,
            bottomLeadingRadius: 16,
            bottomTrailingRadius: 16,
            topTrailingRadius: 0
        ))
        .onTapGesture {
            router.navigateTo(.Notes(friend))
        }
        .onLongPressGesture{
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            modal.openModal(with: AnyView(
                FriendActionsView(friend: friend, editFriend: editFriend(friend:), deleteFriend: deleteFriend(friend: ))
            ))
            
            
        }
    }
    
    func editFriend(friend: Friend){
        router.navigateTo(.EditFriend(friend))
        modal.closeModal()
    }
    
    func deleteFriend(friend: Friend){
        modal.closeModal()
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

#Preview {
    NameCardView().environment(Modal(modalContent: AnyView(Text("")))).environment(Router()).modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
