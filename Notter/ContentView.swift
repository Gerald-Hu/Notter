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
        
    }
    
    
}

#Preview {
    ContentView().modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
