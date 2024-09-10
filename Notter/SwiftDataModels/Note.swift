//
//  Note.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftData
import SwiftUI

@Model
class Note {
    
    var uuid: String
    var content: String
    var ofWhom: String
    var dateCreated: String
    var dateModified: String
    
    init(content: String, ofWhom: String) {
        self.content = content
        self.ofWhom = ofWhom
        self.dateCreated = getCurrentLocalDate()
        self.dateModified = getCurrentLocalDate()
        self.uuid = UUID().uuidString
    }
    
    
}
