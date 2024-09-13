//
//  BackdropBlurView.swift
//  Notter
//
//  Created by Gerald on 2024-08-13.
//

import SwiftUI

struct BackdropBlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style = .systemMaterialLight
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview {
    BackdropBlurView()
}
