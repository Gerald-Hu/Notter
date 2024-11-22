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
    
    @State private var isWiggling = true
    
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
                
                if (friends.count == 0){
                    GeometryReader{ proxy in
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                VStack(spacing: 24) {
                                    
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.all, 36)
                                        .frame(width: 120, height: 120)
                                        .foregroundStyle(Color.tone1.opacity(0.1))
                                        .background(Circle().fill(.tone1Tertiary).opacity(0.2))
                                    
                                    
                                    Text("Who's First? 👀")
                                        .foregroundStyle(.tone1Secondary).opacity(0.9)
                                        .font(.custom("JacquesFrancoisShadow-Regular", size: 20))
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 16,
                            topTrailingRadius: 0
                        ).fill(.bgPrimary).stroke(.tone1Tertiary, style: StrokeStyle(lineWidth: 2, dash: [2, 2, 2, 2])))
                        .frame(width: proxy.size.width * 0.52, height: proxy.size.height * 0.9)
                        
                    }
                    .frame(height: UIScreen.height * 0.25)
                    
                }
                
            }
            .padding(.top, 16)
            
        }
        .padding(.bottom, 80)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    Home().modelContainer(for: [Friend.self, Note.self, AppConfig.self], inMemory: true).environment(Router()).environment(Modal(modalContent: AnyView(Text(""))))
}
