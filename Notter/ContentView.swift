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
    
    @Query private var appConfig: [AppConfig]
    
    var body: some View {
        
        ModalView{
            RouterView{
                Home()
            }
        }
        .onAppear{
            if (appConfig.isEmpty) {
                let newAppConfig = AppConfig()
                modelContext.insert(newAppConfig)
            }
            
        }
        
        
    }
    
    
}

#Preview {
    ContentView().modelContainer(for: [Friend.self, Note.self, AppConfig.self], inMemory: true)
}
