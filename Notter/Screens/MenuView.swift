//
//  MenuView.swift
//  Notter
//
//  Created by Gerald on 2024-11-21.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(Router.self) var router
    
    @State private var selectedTab = 0
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                Text("Menu")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.tone2)
                    .padding(.top, 20)
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                
                // Menu Items Container
                ScrollView {
                    VStack(spacing: 15) {
                        // Welcome Menu Item
                        MenuItemButton(
                            title: "Welcome",
                            icon: "hand.wave.fill",
                            description: "I want to be welcomed again! 👀",
                            destination: Onboarding(),
                            delay: 0.1
                        ).onTapGesture {
                            router.navigateTo(.Onboarding)
                        }
                        
                        // Placeholder items with disabled state
                        MenuItemButton(
                            title: "Coming Soon",
                            icon: "star.fill",
                            description: "More features on the way",
                            destination: EmptyView(),
                            delay: 0.2,
                            isDisabled: true
                        )
                        
                        MenuItemButton(
                            title: "Stay Tuned",
                            icon: "bell.fill",
                            description: "Exciting updates coming",
                            destination: EmptyView(),
                            delay: 0.3,
                            isDisabled: true
                        )
                    }
                    .padding()
                }
            }
            
            VStack{
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {router.navigateBack()}){
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.tone4.opacity(0.9))
                    }
                       
                    
                    Spacer()
                    
                }
                .padding(20)
            }
            
        }
        .toolbar(.hidden)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    MenuView().environment(Router())
}

struct MenuItemButton<Destination: View>: View {
    let title: String
    let icon: String
    let description: String
    let destination: Destination
    let delay: Double
    var isDisabled: Bool = false
    
    @State private var isPressed = false
    @State private var isAnimated = false
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(isDisabled ? .gray.opacity(0.3) : .tone3Tertiary)
                        .frame(width: 50, height: 50)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(isDisabled ? .gray : .primary)
                    
                    Text(description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(isDisabled ? .gray.opacity(0.8) : .secondary)
                }
                
                Spacer()
                
                if !isDisabled {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .opacity(0.5)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(
                        color: .black.opacity(0.1),
                        radius: isPressed ? 5 : 10,
                        x: 0,
                        y: isPressed ? 2 : 5
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1)
            .scaleEffect(isAnimated ? 1 : 0.8)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 20)
        }
        .disabled(isDisabled)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                isAnimated = true
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        isPressed = false
                    }
                }
        )
    }
}
