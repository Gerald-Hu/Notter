//
//  NewFriendView.swift
//  Notter
//
//  Created by Gerald on 2024-08-13.
//

import SwiftUI
import PhotosUI

struct NewFriendView: View {
    
    @Namespace var top
    @Namespace var info
    @Namespace var mbtiInput
    
    @Binding var offset: CGFloat
    
    var addFriend: (Friend) -> ()
    
    enum FocusedField {
        case name, mbti
    }
    
    @State private var name: String = ""
    @State private var birthday: Date = Date()
    @State private var mbti: String = ""
    @State private var selectedAvatar: String = "plus"
    @State private var showingAvatarPicker = false
    @State private var selectedColorTone: String = "tone1"
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @FocusState private var focusedField: FocusedField?
    
    let avatars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    let colorTones = ["tone1", "tone2", "tone3", "tone4"]
    
    @State var gradient = LinearGradient(gradient: Gradient(colors: [Color.tone1, Color.tone1Secondary]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @ViewBuilder
    var body: some View {
        
        VStack(spacing: 36) {
            Text("Add a friend")
                .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            ScrollViewReader{ proxy in
                ScrollView(.vertical){
                    
                    VStack(spacing: 16){
                        Text("").frame(height: 1).id(top)
                        avatarSection
                        colorToneSection
                        personalInfoSection.id(info)
                        
                        mbtiSection.id(mbtiInput)
                        
                        
                        Button(action: {
                            let newFriend = Friend(name: name, avatar: selectedAvatar, birthday: dateToString(birthday), mbti: mbti, color: selectedColorTone)
                            
                            if(newFriend.avatar == "custom"){
                                newFriend.avatarImage = selectedImageData
                            }
                            
                            addFriend(newFriend)
                            withAnimation{
                                proxy.scrollTo(info)
                                offset = UIScreen.height * 0.9
                            }
                            
                            selectedAvatar = "plus"
                            name = ""
                            selectedImageData = nil
                            birthday = Date()
                            mbti = ""
                            
                        }, label: {
                            Text("Add Friend +").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundStyle(Color("\(selectedColorTone)-secondary")).padding().background(Color("\(selectedColorTone)-tertiary")).clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                        })
                        
                        HStack{Spacer()}
                        
                        if(focusedField != nil){
                            Rectangle().fill(.clear).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 300)
                        }
                        
                    }
                    .padding()
                    .padding(.bottom, 200)
                }
                .onTapGesture {
                    focusedField = nil
                }
                .onChange(of: focusedField){old, new in
                    if (new == FocusedField.name){
                        withAnimation{
                            proxy.scrollTo(info, anchor: .center)
                        }
                    }else if (new == FocusedField.mbti){
                        withAnimation{
                            proxy.scrollTo(mbtiInput, anchor: .top)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        
    }
    
    var avatarSection: some View {
        VStack {
            if(selectedAvatar != "plus" && selectedAvatar != "custom"){
                Image(selectedAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(selectedColorTone), lineWidth: 3))
                    .onTapGesture {
                        showingAvatarPicker = true
                    }
            }else{
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(selectedColorTone), lineWidth: 3))
                        .onTapGesture {
                            showingAvatarPicker = true
                        }
                }else{
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 36)
                        .frame(width: 120, height: 120)
                        .foregroundStyle(Color("\(selectedColorTone)-tertiary"))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(selectedColorTone), lineWidth: 3))
                        .onTapGesture {
                            showingAvatarPicker = true
                        }
                }
            }
            
            Text("Tap to change avatar")
                .foregroundColor(Color("\(selectedColorTone)-tertiary"))
                .font(.caption)
                .padding(.top, 8)
        }
        .padding(.bottom)
        .sheet(isPresented: $showingAvatarPicker) {
            avatarPickerView
                .presentationDetents([.height(350)])
        }
    }
    
    var avatarPickerView: some View {
        VStack {
            
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 28)
                            .foregroundStyle(Color("\(selectedColorTone)-tertiary"))
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(selectedAvatar == "plus" ? Color.yellow : Color.white, lineWidth: 2))
                    }
                    .onChange(of: selectedItem) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                selectedAvatar = "custom"
                                showingAvatarPicker = false
                            }
                        }
                    }
                    
                    ForEach(avatars, id: \.self) { avatar in
                        Image(avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(selectedAvatar == avatar ? Color.yellow : Color.white, lineWidth: 2))
                            .onTapGesture {
                                selectedAvatar = avatar
                                showingAvatarPicker = false
                            }
                    }
                }
                .padding()
            }
            .padding(.top, 20)
        }
        .background(Color("\(selectedColorTone)"))
    }
    
    var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Friend Basics")
                .font(.headline)
            
            TextField("Name", text: $name)
                .autocorrectionDisabled()
                .textFieldStyle(CustomTextFieldStyle())
                .focused($focusedField, equals: .name)
            
            DatePicker("", selection: $birthday,in: ...Date.now, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
        }
        .foregroundStyle(Color("\(selectedColorTone)-secondary"))
        .padding()
        .background(Color("\(selectedColorTone)-tertiary").opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
    
    var mbtiSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("MBTI Type (Optional)")
                .font(.headline)
            
            
            TextField("My friend is of ...", text: $mbti)
                .textFieldStyle(CustomTextFieldStyle())
                .autocapitalization(.allCharacters)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .mbti)
        }
        .foregroundStyle(Color("\(selectedColorTone)-secondary"))
        .padding()
        .background(Color("\(selectedColorTone)-tertiary").opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var colorToneSection: some View {
            VStack(alignment: .leading, spacing: 15) {
                Text("Color Tone")
                    .font(.headline)
                
                HStack(spacing: 15) {
                    ForEach(colorTones, id: \.self) { tone in
                        ColorToneButton(tone: tone, isSelected: selectedColorTone == tone) {
                            selectedColorTone = tone
                            gradient = LinearGradient(gradient: Gradient(colors: [Color(selectedColorTone), Color("\(selectedColorTone)-secondary")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                    }
                }
            }
            .foregroundStyle(Color("\(selectedColorTone)-secondary"))
            .padding()
            .background(Color("\(selectedColorTone)-tertiary").opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
}

struct ColorToneButton: View {
    let tone: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(Color(tone))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
                    )
                    .shadow(color: isSelected ? Color(tone).opacity(0.6) : Color.clear, radius: 5)
                
                Text(tone.capitalized)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color(tone) : .gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color(tone).opacity(0.2) : Color.clear)
        )
        .animation(.easeInOut, value: isSelected)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .foregroundColor(.tone2)
    }
}

#Preview {

    NewFriendView(offset: .constant(0), addFriend: {a in}).modelContainer(for: [Friend.self, Note.self], inMemory: true)

}
