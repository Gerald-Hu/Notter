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
    @Query var friends: [Friend]
    
    var safeArea: EdgeInsets = EdgeInsets()
    
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
                                
                                Text("Add Some")
                                    .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                                
                                Text("Friends!")
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
                        .padding(.top, safeArea.top + 4)
                        
                        Spacer()
                        
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
                                            $0.background(RoundedRectangle(cornerRadius: 999).fill(.bgPrimary).stroke(.black, style: StrokeStyle(lineWidth: 2)))
                                        }
                                        .if(currentClustering != clustering){
                                            $0.background(Capsule().fill(.bgPrimary).stroke(.black, style: StrokeStyle(lineWidth: 1, dash: [2])))
                                        }
                                        .onTapGesture {
                                            currentClustering = clustering
                                            if(clustering == "All"){

                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                }
                .padding(.bottom, 16)
                .frame(height: UIScreen.height * 0.24)
                .background(Image(.bgCloth1).resizable().scaledToFill().ignoresSafeArea())
                
                
                HomeListView(clustering: currentClustering)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                    .background(.bgPrimary)
                    .frame(height: UIScreen.height * 0.82)
                    .ignoresSafeArea()
                    .shadow(radius:4, x: 5, y: 5)
            }
            
            DrawerView(addFriend: addFriend(friend:))
        }
        .onAppear{
            updateClusterings()
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
    
}

#Preview {
    ContentView().modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
