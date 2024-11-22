//
//  Home.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext
    @Environment(Modal<AnyView>.self) var modal
    
    @Query var friends: [Friend]
    @Query private var appConfig: [AppConfig]
    
    @State var currentClustering: String = "All"
    @State var clusterings: [String] = []
    @State var currentFriendCount = 0
    
    @ViewBuilder
    var body: some View {
        
        ZStack{
            
            VStack(spacing: 0){
                
                VStack(alignment: .leading){
                    
                    HStack {
                        VStack(alignment: .leading){
                            if(friends.count == 0) {
                                
                                Text("Shh...looks like")
                                    .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                                
                                
                                Text("it's quiet here.")
                                    .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                                
                            }else{
                                if currentClustering == "All" {
                                    Text("\(friends.count) of \(friends.count)")
                                        .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                                }else{
                                    Text("\(friends.filter{$0.firstChar == currentClustering}.count) of \(friends.count)")
                                        .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                                }
                                
                                Text("Friends ❤️")
                                    .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                                
                                
                            }
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        MenuButtonView().padding(.trailing,20).onTapGesture {
                            router.navigateTo(.Menu)
                            
                        }
                    }
                    
                    Spacer()
                    
                    if (friends.count != 0) {
                        ScrollView(.horizontal){
                            HStack(spacing: 16){
                                
                                ForEach(clusterings, id: \.self){ clustering in
                                    Text(clustering)
                                        .font(.custom("Kavoon-Regular", size: 16))
                                        .padding(.vertical,4)
                                        .frame(width: 68)
                                        .if(currentClustering == clustering){
                                            $0.background(
                                                ZStack {
                                                    Capsule().fill(.black)
                                                    Capsule().fill(.bgPrimary).padding(.horizontal, 2).padding(.vertical, 2)
                                                }
                                            )
                                        }
                                        .if(currentClustering != clustering){
                                            $0.background(Capsule().fill(.bgPrimary).stroke(.black, style: StrokeStyle(lineWidth: 1, dash: [2])))
                                        }
                                        .onTapGesture {
                                            currentClustering = clustering
                                        }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                }
                .padding(.bottom, 16)
                .frame(minHeight: 130, idealHeight: UIScreen.height * 0.15, maxHeight: UIScreen.height * 0.15)
                .background(Image(.bgCloth1).resizable().frame(height: UIScreen.height * 0.3).ignoresSafeArea())
                
                
                HomeListView(clustering: currentClustering)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                    .background(.bgPrimary)
                    .ignoresSafeArea()
                    .if(friends.count != 0){
                        $0.shadow(radius:4, x: 5, y: 5)
                    }
                
            }
            
            DrawerView(addFriend: addFriend(friend:))
            
        }
        .toolbar(.hidden)
        .onAppear{
            maybeNavToOnboarding()
            updateClusterings()
            print(router.path.count)
        }
        .onChange(of: friends.count){
            updateClusterings()
        }
        
    }
    
    func addFriend(friend: Friend){
        Task{
            modelContext.insert(friend)
        }
        
    }
    
    func deleteFriend(friend: Friend){
        Task{
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
    
    func updateClusterings(){
        var tempClusterings: [String] = []
        
        for friend in self.friends {
            let firstChar = friend.name.prefix(1).uppercased()
            if !tempClusterings.contains(firstChar){
                tempClusterings.append(firstChar)
            }
        }
        
        self.clusterings = ["All"] + tempClusterings.sorted()
    }
    
    private func maybeNavToOnboarding() {
        if let config = appConfig.first, !config.welcomed{
            router.navigateTo(.Onboarding)
        }
    }
    
}

#Preview {
    Home().modelContainer(for: [Friend.self, Note.self, AppConfig.self], inMemory: true).environment(Router()).environment(Modal(modalContent: AnyView(Text(""))))
}
