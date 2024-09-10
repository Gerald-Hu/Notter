//
//  FabView.swift
//  Notter
//
//  Created by Gerald on 2024-08-12.
//

import SwiftUI

struct FabView: View {
    
    var color: String = "tone1"
    var systemIcon: String = "plus"
    var leading: Bool = false
    var trailing: Bool = false
    
    let action: () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            
            HStack{
                
                if (trailing){
                    Spacer()
                }
                
                Button(action: action) {
                    Image(systemName: systemIcon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color(color))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 4, x: 0, y: 4)
                }
                
                if(leading){
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            
        }
        .padding(.bottom, 16)
    }
    
}

#Preview {
    FabView(action: {})
}
