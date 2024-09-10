//
//  Modal.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI

@Observable
class Modal<Content: View>{
    
    var modalContent: Content?
    var modalIsOpen: Bool
    var showCloseIcon: Bool
    
    init(modalContent: Content) {
        self.modalContent = modalContent
        self.modalIsOpen = false
        self.showCloseIcon = false
    }
    
    func openModal(with modalContent: Content){
        self.modalContent = modalContent
        self.modalIsOpen = true
    }
    
    func closeModal(){
        self.modalIsOpen = false
        self.modalContent = nil
        self.showCloseIcon = false
    }
    
    func shouldShowCloseIcon(){
        self.showCloseIcon = true
    }
    
}

struct ModalView<Content: View>: View {
    
    @Bindable var modal: Modal = Modal(modalContent: AnyView(Text("")))
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        ZStack{
            
            content
                .environment(modal)
            
            if(modal.modalIsOpen){
                BackdropBlurView(style: .systemMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        modal.closeModal()
                    }
                
                modal.modalContent
                
                if(modal.showCloseIcon) {
                    VStack{
                    
                    HStack {
                        Spacer()
                        Image(systemName: "x.circle")
                            .resizable()
                            .scaledToFit()
                            .background(.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                modal.closeModal()
                            }
                    }
                    .padding(.trailing, 28)
                    .padding(.top, 16)
                    
                    Spacer()
                    
                }
            }
            }
            
            
        }
        
    }
    
}

#Preview {
    ModalView{
        AnyView(Text(""))
    }
}
