//
//  AvatarView.swift
//  Notter
//
//  Created by Gerald on 2024-08-13.
//

import SwiftUI

struct AvatarView: View {
    
    @Environment(Modal<AnyView>.self) var modal
    
    var avatar = "1"
    var avatarImage: Data? = nil
    var viewable: Bool = false
    var scale: CGFloat = 1
    var offset: CGSize = .zero
    var color: String = ""
    
    var body: some View {
        
        ZStack{
            
            Circle()
                .fill(Color("\(color)-tertiary").opacity(0.8))
                .frame(width: 120, height: 120)
            
            if avatar == "custom", let avatarImage, let uiImage = UIImage(data: avatarImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(scale)
                    .offset(offset)
                    .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .frame(width: 120, height: 120)
                    .if(viewable){
                        $0.onTapGesture {
                            modal.shouldShowCloseIcon()
                            modal.openModal(with: AnyView(PhotoView(image: Image(uiImage: uiImage))))
                        }
                    }
            }else{
                Image(avatar)
                    .resizable()
                    .scaledToFit()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .frame(width: 120, height: 120)
                    .if(viewable){
                        $0.onTapGesture {
                            modal.shouldShowCloseIcon()
                            modal.openModal(with: AnyView(PhotoView(image: Image(avatar))))
                        }
                    }
            }
            
        }
        
    }
}

#Preview {
    AvatarView().environment(Modal(modalContent: AnyView(Text(""))))
}
