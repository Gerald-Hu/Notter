//
//  EditAvatarView.swift
//  Notter
//
//  Created by Gerald on 2024-11-17.
//

import SwiftUI
import SwiftData

struct EditAvatarView: View {
    var friend: Friend
    var finishEdit: ()->()
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var lastScale: CGFloat = 1.0
    
    @State private var isGestureOngoing = false
    
    let ratio = 120 / (UIScreen.width - 24 - 24)
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 3.0
    
    // Track raw gesture translation
    @State private var gestureTranslation: CGSize = .zero
    
    private let feedback = UIImpactFeedbackGenerator(style: .light)
    
    private func calculateMaxOffset(for scale: CGFloat, size: CGFloat) -> CGFloat {
        return (size * (scale - 1)) / 2
    }
    
    private func limitOffset(_ offset: CGSize, for scale: CGFloat, size: CGFloat) -> CGSize {
        let maxOffsetX = calculateMaxOffset(for: scale, size: size)
        let maxOffsetY = calculateMaxOffset(for: scale, size: UIScreen.width + 96)
        return CGSize(
            width: offset.width.clamped(to: -maxOffsetX...maxOffsetX),
            height: offset.height.clamped(to: -maxOffsetY...maxOffsetY)
        )
    }
    
    private func applyConstraints(animate: Bool = true) {
        let size = UIScreen.width - 24 - 24
        let newScale = scale.clamped(to: minScale...maxScale)
        let newOffset = limitOffset(offset, for: newScale, size: size)
        
        let needsCorrection = newScale != scale || newOffset != offset
        
        if needsCorrection {
            feedback.impactOccurred()
            
            if animate {
                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                    scale = newScale
                    offset = newOffset
                }
            } else {
                scale = newScale
                offset = newOffset
            }
            
        }
        
        lastOffset = newOffset
        lastScale = newScale
        
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color("\(friend.color)-secondary").opacity(0.8))
                    .frame(width: UIScreen.width - 24 - 24, height: UIScreen.width - 24 - 24)
                
                if friend.avatar == "custom",
                   let imageData = friend.avatarImage,
                   let uiImage = UIImage(data: imageData) {
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: UIScreen.width - 24 - 24, height: UIScreen.width - 24 - 24)
                        .overlay {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .scaleEffect(scale)
                                .offset(offset)
                                .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .clipShape(Circle())
                        }
                        .gesture(
                            SimultaneousGesture(
                                DragGesture()
                                    .onChanged { value in
                                        isGestureOngoing = true
                                        gestureTranslation = value.translation
                                        
                                        
                                        // Calculate new offset considering scale
                                        let proposedOffset = CGSize(
                                            width: lastOffset.width + gestureTranslation.width,
                                            height: lastOffset.height + gestureTranslation.height
                                        )
                                        
                                        // Allow free movement during gesture
                                        offset = proposedOffset
                                        
                                    }
                                    .onEnded { _ in
                                        isGestureOngoing = false
                                        gestureTranslation = .zero
                                        applyConstraints()
                                    },
                                MagnificationGesture()
                                    .onChanged { value in
                                        isGestureOngoing = true
                                        scale = lastScale * value
                                        
                                        // Adjust offset proportionally when scaling
                                        let scaleFactor = scale / lastScale
                                        offset = CGSize(
                                            width: lastOffset.width * scaleFactor,
                                            height: lastOffset.height * scaleFactor
                                        )
                                    }
                                    .onEnded { _ in
                                        isGestureOngoing = false
                                        applyConstraints()
                                    }
                            )
                        )
                } else {
                    Image(friend.avatar)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            
            if (friend.avatar == "custom"){
                Button("Reset Position") {
                    feedback.impactOccurred(intensity: 0.7)
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0)) {
                        scale = 1.0
                        offset = .zero
                        lastScale = 1.0
                        lastOffset = .zero
                        gestureTranslation = .zero
                    }
                }
                .foregroundStyle(Color("\(friend.color)-tertiary"))
                .padding()
            }
            
            Spacer()
            
            if(friend.avatar == "custom"){
                HStack {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .opacity(0.7)
                        .onTapGesture {
                            finishEdit()
                        }
                    
                    Spacer()
                    
                    Image("check")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .onTapGesture {
                            applyConstraints(animate: true)
                            saveTransformation()
                            finishEdit()
                        }
                }
                .padding(.horizontal, 28)
                .padding(.leading, 6)
            }else{
                HStack {
                    
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .opacity(0.7)
                        .onTapGesture {
                            finishEdit()
                        }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 28)
                .padding(20)
            }
        }
        .background(Color(friend.color).opacity(0.98))
        .onAppear {
            feedback.prepare()
            scale = friend.avatarScale ?? 1.0
            offset = CGSize(
                width: (friend.avatarOffsetX ?? .zero) / ratio,
                height: (friend.avatarOffsetY ?? .zero) / ratio
            )
            lastScale = scale
            lastOffset = offset
            applyConstraints(animate: false)
        }
    }
    
    private func saveTransformation() {
        friend.avatarScale = scale
        friend.avatarOffsetX = offset.width * ratio
        friend.avatarOffsetY = offset.height * ratio
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

#Preview {
    EditAvatarView(friend: Friend(name: "a", avatar: "1", birthday: "", mbti: "", color: "tone4"), finishEdit: { })
}
