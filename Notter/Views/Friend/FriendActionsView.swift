//
//  FriendActionsView.swift
//  Notter
//
//  Created by Gerald on 2024-08-13.
//

import SwiftUI

struct FriendActionsView: View {
    
    var friend: Friend
    
    var editFriend: (Friend) -> () = {a in}
    var deleteFriend: (Friend) -> () = {a in}
    
    var body: some View {
        VStack{
            
            Spacer()
            
            HStack{
                
                if friend.avatar == "custom", let avatarImage = friend.avatarImage, let uiImage = UIImage(data: avatarImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(friend.avatarScale ?? 1.0)
                        .offset(CGSize(width: friend.avatarOffsetX ?? .zero, height: friend.avatarOffsetY ?? .zero))
                        .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .frame(width: 120, height: 120)

                }else{
                    Image(friend.avatar)
                        .resizable()
                        .scaledToFit()
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .frame(width: 120, height: 120)
                }
                
                Spacer()
                
                VStack(spacing: 4){
                    Text(friend.name)
                        .font(.custom("JacquesFrancoisShadow-Regular", size: 28))
                    
                    if(friend.mbti != "") {
                        Text(friend.mbti)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("\(friend.color)-tertiary"))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .overlay(Capsule().fill(.clear).stroke(Color("\(friend.color)-tertiary"), lineWidth: 1))
                    }
                    
                    Text(friend.birthday)
                        .font(.custom("JacquesFrancoisShadow-Regular", size: 28))
                }
                .foregroundStyle(.white)
                
                Spacer()
                
            }
            .padding()
            .background(Color("\(friend.color)"))
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16,
                topTrailingRadius: 0
            ))
            
            Spacer()
            
            HStack(spacing: 100){
                
                Image(systemName: "pencil.line")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 68, height: 68)
                    .background(.gray.opacity(0.15))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        editFriend(friend)
                    }
                
                
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 68, height: 68)
                    .background(.gray.opacity(0.15))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        deleteFriend(friend)
                    }
                
                
            }
            
            
            Spacer()
        }
        .padding()
        .shadow(radius: 10)
    }
    
}

#Preview {
    FriendActionsView(friend: Friend(name: "Jordina", avatar: "1", birthday: "1998-04-01", mbti: "intp", color: "tone1"))
}
