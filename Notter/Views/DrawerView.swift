//
//  DrawerView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI
import SwiftData

struct DrawerView: View {
    
    private let maxOffset = UIScreen.height * 0.9
    private let minOffset = UIScreen.height * 0.1
    
    @State private var offset: CGFloat = UIScreen.height * 0.9
    @State private var startOffset: CGFloat = -1
    @State private var dragStartOffsetY: CGFloat = -1
    
    let addFriend: (Friend) -> ()
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            
            if offset < UIScreen.height * 0.5 {
                Color.secondary.opacity((0.7 - offset / maxOffset)).ignoresSafeArea()
                    .onTapGesture {
                        withAnimation{
                            offset = maxOffset
                        }
                    }
            }
            
            GeometryReader{ proxy in
                
                
                    BackdropBlurView()
                    

                NewFriendView(offset: $offset, addFriend: addFriend)
                            .padding(.top, 16)

                
                
            }
            .cornerRadius(32)
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        
                        if offset == maxOffset {
                            return
                        }
                        
                        if dragStartOffsetY == -1 {
                            dragStartOffsetY = value.location.y
                        }
                        
                        if(startOffset == -1){
                            startOffset = value.startLocation.y
                        }
                        
                        offset = max(min((startOffset + value.translation.height), maxOffset), minOffset)
                        
                        
                    }
                    .onEnded{ value in
                        
                        withAnimation{
                            
                            
                            startOffset = offset
                            
                            if dragStartOffsetY - value.predictedEndLocation.y > 250 || offset < 150 {
                                offset = minOffset
                                startOffset = minOffset
                            }
                            
                            else if dragStartOffsetY - value.predictedEndLocation.y < -250 || offset > 150{
                                offset = maxOffset
                                startOffset = maxOffset
                            }
                            
                        }
                        
                        dragStartOffsetY = -1
                        
                    }
            )
            .onTapGesture {
                
                if offset != maxOffset {
                    return
                }
                
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                
                withAnimation{
                    if (offset == maxOffset){
                        offset = minOffset
                        startOffset = offset
                    }
                }
                
            }
            .shadow(radius: 6)
            .ignoresSafeArea()
            
        }
        
    }
}

#Preview {
    ZStack{
        Image("1")
        DrawerView(addFriend: {a in})
    }
}
