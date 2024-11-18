//
//  Friend.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftData
import SwiftUI

@Model
class Friend {
    
    var uuid: String
    var name : String
    var avatar : String
    var birthday : String
    var mbti : String
    var color: String
    
    // Use to support clustering - #Predicate Macro does not support functions
    var firstChar: String
    
    // For Custom Avatar
    var avatarScale: CGFloat? = 1.0
    var avatarOffsetX: CGFloat? = 0.0
    var avatarOffsetY: CGFloat? = 0.0
    
    @Attribute(.externalStorage)
    var avatarImage: Data?
    
    init(name: String, avatar: String, birthday: String, mbti: String, color: String) {
        self.name = name
        self.avatar = avatar
        self.birthday = birthday
        self.mbti = mbti
        self.color = color
        self.uuid = UUID().uuidString
        
        self.firstChar = name.prefix(1).uppercased()
    }
    
    
}
