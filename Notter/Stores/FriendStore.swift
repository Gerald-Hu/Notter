//
//  FriendStore.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//
import Foundation
import SwiftData
import SwiftUI

@Observable
class FriendStore {

    
    var friends: [Friend]
    var clusterings: [String]
    var currentClustering: String
    var clusteredFriends: [Friend]
    
    init() {
        self.friends = []
        self.clusterings = []
        self.currentClustering = "All"
        self.clusteredFriends = []
    }
    
    func updateFriends(with friends: [Friend]) {
        
        self.friends = friends
        
        if (currentClustering == "All") {
            self.clusteredFriends = self.friends
        }else{
            self.clusteredFriends = self.friends.filter{$0.name.prefix(1).uppercased() == self.currentClustering}
        }
        
        var tempClusterings: [String] = []
        
        for friend in friends {
            let firstChar = friend.name.prefix(1).uppercased()
            if !tempClusterings.contains(firstChar){
                tempClusterings.append(firstChar)
            }
        }
        self.clusterings = ["All"] + tempClusterings.sorted()
    }
    
    func updateClusterings(with clustering: String){
        
        self.currentClustering = clustering
        
        if (currentClustering == "All") {
            self.clusteredFriends = self.friends
        }else{
            self.clusteredFriends = self.friends.filter{$0.name.prefix(1).uppercased() == self.currentClustering}
        }
        
    }
    
    
}
