//
//  OnboardingView.swift
//  Notter
//
//  Created by Gerald on 2024-11-19.
//

import SwiftUI
import SwiftData

struct Onboarding: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) var router
    
    @Query private var appConfig: [AppConfig]
    
    @State private var currentTab = 0
    @State private var maxTab = 0
    @State private var showButton = false
    
    struct OnboardingSlide {
        let image: String
        let title: String
        let description: String
    }
    
    private let slides = [
        OnboardingSlide(
            image: "Onboarding1",
            title: "Welcome to \n Notter!",
            description: "Your friend collection starts here, where each friend gets their own story timeline."
        ),
        OnboardingSlide(
            image: "Onboarding2",
            title: "Style Your Squad!",
            description: "All your friends are unique, so style them with color themes and avatars before you add stories ✨"
        ),
        OnboardingSlide(
            image: "Onboarding3",
            title: "Friend Cards with Magics soon!",
            description: "Stay toned for new features like Generate personal friend cards and turn memories into shareable snapshots."
        )
    ]
    
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(0..<slides.count, id: \.self) { index in
                
                ZStack{
                    
                    VStack(spacing: 20) {
                        
                        Spacer()
                        
                        
                        ZStack {
                            Text(slides[index].title)
                                .font(.custom("Bryndan Write", size: 36))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .offset(x: 2, y: 2)
                                .frame(width: 240, height: .infinity)
                            
                            Text(slides[index].title)
                                .font(.custom("Bryndan Write", size: 36))
                                .multilineTextAlignment(.center)
                                .frame(width: 240, height: .infinity)
                        }
                        
                        Spacer()
                        
                        Text(slides[index].description)
                            .lineLimit(10)
                            .font(.custom("Bryndan Write", size: 24))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .foregroundColor(.tone3.opacity(0.8))
                            .frame(width: UIScreen.width * 0.9, height: .infinity)
                        
                        Spacer()
                        
                        Image(slides[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.blue)
                            .padding()
                        
                        
                        
                        Spacer()
                    }
                    
                    if(showButton && index == slides.count - 1){
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    markAsWelcomed()
                                }) {
                                    Image(.continueButton).resizable().scaledToFit().frame(width: 70)
                            }
                                .padding(24)
                                .modifier(FloatingAnimation())
                                .modifier(StampEntrance())
                            }
                            .shadow(radius: 4, x: 2, y: 2)
                        }
                    }
                }
                
                .tag(index)
            }
        }
        .background(
            GeometryReader { geo in
                Image(.onboardingBg)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.width * 3 + 6)
                    .offset(x: -UIScreen.width * CGFloat(currentTab) - 1)
                    .animation(.easeInOut, value: currentTab)
            }
        )
        .ignoresSafeArea()
        .toolbar(.hidden)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onChange(of: currentTab){ old, new in
            if old < new && new > maxTab {
                if(maxTab == 0){
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }else{
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                maxTab = new
            }
            
            if maxTab == 2 && !showButton {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    withAnimation{
                        showButton = true
                    }
                }
            }
        }
        .onAppear {
            // Prevent overscroll iff user is here
            UIScrollView.appearance().bounces = false
        }
    }
    
    private func markAsWelcomed() {
        if let config = appConfig.first {
            config.welcomed = true
            try? modelContext.save()
            currentTab = 0
        }
        
        // Re-enable overscroll after user leaves the page
        UIScrollView.appearance().bounces = true
        router.navigateBack()
    }
}

#Preview {
    Onboarding().modelContainer(for: [Friend.self, Note.self, AppConfig.self], inMemory: true).environment(Router())
}

struct FloatingAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? -8 : 0)
            .animation(
                Animation.easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct StampEntrance: ViewModifier {
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(hasAppeared ? 1.0 : 2.0)
            .opacity(hasAppeared ? 1.0 : 0.0)
            .animation(
                .spring(
                    response: 0.6,
                    dampingFraction: 0.6,
                    blendDuration: 0.9
                ),
                value: hasAppeared
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    hasAppeared = true
                }
            }
    }
}
