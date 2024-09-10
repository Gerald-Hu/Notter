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
    
    var body: some View {

            if avatar == "custom", let avatarImage, let uiImage = UIImage(data: avatarImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
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

#Preview {
    AvatarView().environment(Modal(modalContent: AnyView(Text(""))))
}
