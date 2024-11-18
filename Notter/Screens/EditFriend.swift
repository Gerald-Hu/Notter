//
//  EditFriend.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI
import PhotosUI
import SwiftData

struct EditFriend: View {
    
    @Environment(Router.self) var router
    
    var friend: Friend
    
    var addFriend: ()->() = {}
    
    @Namespace var top
    @Namespace var info
    @Namespace var mbtiInput
    
    @Environment(\.modelContext) private var modelContext
    
    
    enum FocusedField {
        case name, mbti
    }
    
    @State private var name: String
    @State private var birthday: Date
    @State private var mbti: String
    @State private var selectedAvatar: String
    @State private var showingAvatarPicker = false
    @State private var selectedColorTone: String
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @FocusState private var focusedField: FocusedField?
    
    init(friend: Friend) {
        self.friend = friend
        self.name = friend.name
        self.birthday = stringToDate(friend.birthday)
        self.mbti = friend.mbti
        self.selectedAvatar = friend.avatar
        self.selectedColorTone = friend.color
        self.selectedItem = nil
        self.selectedImageData = friend.avatarImage
    }
    
    let avatars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    let colorTones = ["tone1", "tone2", "tone3", "tone4"]
    
    @State var gradient = LinearGradient(gradient: Gradient(colors: [Color.tone1, Color.tone1Secondary]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @ViewBuilder
    var body: some View {
        
        ScrollViewReader{ proxy in
            ScrollView(.vertical){
                
                VStack(spacing: 16){
                    
                    Text("Edit Friend")
                        .font(.custom("JacquesFrancoisShadow-Regular", size: 32))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    avatarSection
                    colorToneSection
                    personalInfoSection.id(info)
                    
                    mbtiSection.id(mbtiInput)
                    
                    
                    Button(action: {
                        router.navigateBack()
                    }, label: {
                        Text("Finish").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundStyle(Color("\(selectedColorTone)-secondary")).padding().background(Color("\(selectedColorTone)-tertiary")).clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                    })
                    
                    if(focusedField != nil){
                        Rectangle().fill(.clear).frame(width: 100, height: 0)
                    }
                    
                }
                .padding()
                .onChange(of: focusedField){old, new in
                    if (new == FocusedField.name){
                        withAnimation{
                            proxy.scrollTo(info)
                        }
                    }else if (new == FocusedField.mbti){
                        withAnimation{
                            proxy.scrollTo(mbtiInput, anchor: .top)
                        }
                    }
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden)
        
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
                
                if let selectedImageData = friend.avatarImage,
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
        .padding(.all)
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
                                
                                await MainActor.run {
                                    friend.avatar = "custom"
                                    friend.avatarImage = selectedImageData
                                    friend.avatarOffsetX = .zero
                                    friend.avatarOffsetY = .zero
                                    friend.avatarScale = 1.0
                                }
                                
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
                                friend.avatar = avatar
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
                .onChange(of: name){ old, new in
                    friend.name = new
                    friend.firstChar = new.prefix(1).uppercased()
                }
            
            DatePicker("", selection: $birthday,in: ...Date.now, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .onChange(of: birthday){ old, new in
                    let newbirthDay = dateToString(birthday)
                    friend.birthday = newbirthDay
                }
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
        .onChange(of: mbti){ old, new in
            friend.mbti = new
        }
        
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
        .onChange(of: selectedColorTone){ old, new in
            friend.color = new
        }
    }
}

#Preview {
    EditFriend(friend: Friend(name: "Jerry", avatar: "1", birthday: "1998-04-23", mbti: "intp", color: "tone2")).environment(Router()).modelContainer(for: [Friend.self, Note.self], inMemory: true)
}
