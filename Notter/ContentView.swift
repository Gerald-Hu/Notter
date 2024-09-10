//
//  ContentView.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State var friendStore: FriendStore = FriendStore()
    
    var body: some View {
        
        ModalView{
            RouterView{
                
                GeometryReader {
                    let safeArea = $0.safeAreaInsets
                    
                    Home(safeArea: safeArea)
                        .ignoresSafeArea()
                }
            }
        }
        .environment(friendStore)
        .onAppear{
            
            Task{
                let friendPredicate = #Predicate<Friend>{friend in true}
                let friends = try modelContext.fetch(FetchDescriptor<Friend>(predicate: friendPredicate))
                friendStore.updateFriends(with: friends)
            }
            
        }
        
    }
    
    
}

#Preview {
    ContentView().modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
