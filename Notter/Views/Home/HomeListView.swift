//
//  HomeListView.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI
import SwiftData

struct HomeListView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var friends: [Friend]
    
    var clustering: String
    
    init(clustering: String){
        
        self.clustering = clustering
        
        _friends = Query(filter: #Predicate { friend in
            clustering == "All" || friend.firstChar == clustering
        })

    }
    
    func getA() -> Bool{
        return true
    }
    
    var body: some View {
        ScrollView(.vertical){
            
            if friends.count == 0 {
                HStack{
                    Spacer()
                }
            }
            
            VStack(spacing: 16){
                ForEach(friends.indices, id: \.self){ i in
                    VStack(spacing: -4){
                    if(i < friends.count / 4 + 1){
                        
                        if(i * 4 < friends.count){
                            GeometryReader{ proxy in
                                HStack(alignment: .top, spacing: 16){
                                    if(i * 4 < friends.count){
                                        NameCardView(friend: friends[i * 4])
                                            .frame(width: proxy.size.width * 0.52, height: proxy.size.height * 0.9)
                                    }
                                    
                                    if(i * 4 + 1 < friends.count){
                                        NameCardView(friend: friends[i * 4 + 1])
                                            .frame(width: proxy.size.width * 0.48 - 16, height: proxy.size.height)
                                    }
                                }
                                
                            }
                            .frame(height: UIScreen.height * 0.25)
                        }
                        
                        if(i * 4 + 2 < friends.count){
                            GeometryReader{ proxy in
                                HStack(alignment: .bottom, spacing: 16){
                                    if(i * 4 + 2 < friends.count){
                                        NameCardView(friend: friends[i * 4 + 2])
                                            .frame(width: proxy.size.width * 0.48 - 16, height: proxy.size.height)
                                    }
                                    
                                    if(i * 4 + 3 < friends.count){
                                        NameCardView(friend: friends[i * 4 + 3])
                                            .frame(width: proxy.size.width * 0.52, height: proxy.size.height * 0.9)
                                    }
                                }
                                
                            }
                            .frame(height: UIScreen.height * 0.25)
                        }
                    }
                }
                }
            }
            .padding(.top, 16)
            
        }
        .padding(.bottom, 80)
        .scrollIndicators(.hidden)
        .onAppear{
            
        }
    }
}

#Preview {
    ContentView().modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
