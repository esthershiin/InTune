//
//  UserData.swift
//  InTune
//
//  Created by Allyson, Esther, Junna on 4/23/20.
//

/* Notes for development: Will probably need an abstraction for a user (class or struct?). The class will need a username, name, date joined, top match, average match score, and maybe a data structure that holds all the matches. */

import Foundation
import Firebase

//Firebase reference
let db = Firestore.firestore()

//authtoken and refresh token must be persistent
var authToken: String?
var refreshToken: String?

class user {
    var name: String
    var avgScore: Int
    var numMatches: Int
    var outgoings = [user]()
    var incomings = [user]()
    var matches = [match]()
    var startDate: Date
    
    init(name: String) {
        self.name = name
        avgScore = 0
        numMatches = 0
        matches = [match]()
        outgoings = [user]()
        incomings = [user]()
        startDate = Date()
        addUserToFS()
    }
    
    //shallow test of equality
    func equalsUser(other: user) -> Bool {
        if (name != other.name || numMatches != other.numMatches) {
            return false
        } else if (avgScore != other.avgScore || startDate != other.startDate) {
            return false
        } else {
            return true
        }
    }
    
    //request a user
    func requestUser(otherUser: user) {
        outgoings.append(otherUser)
        otherUser.incomings.append(self)
        
        updateOutgoingsFS()
        otherUser.updateIncomingsFS()
    }
    
    //remove a request (decline request?)
    func removeRequest(otherUser: user) {
        removeUser(arr: incomings, other: otherUser)
        removeUser(arr: otherUser.outgoings, other: self)
        
        updateIncomingsFS()
        otherUser.updateOutgoingsFS()
    }
    
    //accept an incoming request and update the other user's status
    func acceptRequest(otherUser: user) {
        addMatch(other: otherUser)
        otherUser.addMatch(other: self)
        removeRequest(otherUser: otherUser)
        
        //fixme
        updateIncomingsFS()
    }
    
    //add a match
    func addMatch(other: user) {
        let newMatch = match(userA: self, userB: other)
        avgScore = (avgScore * numMatches + newMatch.score) / (numMatches + 1)
        numMatches += 1
        matches.append(newMatch)
        
        //fixme
    }
    
    //remove user from a given array (meant for incomings and outgoings)
    func removeUser(arr: [user], other: user) {
        for (i, user) in arr.enumerated() {
            if (user.equalsUser(other: other)) {
                incomings.remove(at: i)
                break
            }
        }
    }
    
    //Firestore
    
    //add inital user data to Firestore
    func addUserToFS() {
        var outgoingUsernames = [String]()
        for outUser in outgoings {
            outgoingUsernames.append(outUser.name)
        }
        var incomingUsernames = [String]()
        for inUser in incomings {
            incomingUsernames.append(inUser.name)
        }
        var matchContents = [Any]()
        for match in matches {
            let new = ["date": match.date, "score": match.score,
                       "topTracks": match.topTracks, "topArtists": match.topArtists] as [String : Any]
            matchContents.append([match.userB.name: new])
        }
        db.collection("users").document(name).setData([
            "name": name,
            "avgScore": avgScore,
            "numMatches": numMatches,
            "matches": matchContents,
            "outgoings": outgoingUsernames,
            "incomings": incomingUsernames,
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written")
            }
        }
    }
    
    //update avgScore on Firestore
    func updateAvgScoreFS() {
        let userRef = db.collection("users").document(name)
        userRef.updateData([
            "avgScore": avgScore,
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document sucessfully updated")
            }
        }
    }
    
    
    //update outgoings on Firestore
    func updateOutgoingsFS() {
        var outgoingUsernames = [String]()
        for outUser in outgoings {
            outgoingUsernames.append(outUser.name)
        }
        let userRef = db.collection("users").document(name)
        userRef.updateData([
            "outgoings": outgoingUsernames,
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document sucessfully updated")
            }
        }
    }
    
    //update incomings on Firestore
    func updateIncomingsFS() {
        var incomingUsernames = [String]()
        for inUser in incomings {
            incomingUsernames.append(inUser.name)
        }
        let userRef = db.collection("users").document(name)
        userRef.updateData([
            "incomings": incomingUsernames,
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document sucessfully updated")
            }
        }
    }
    
    //update matches on Firestore
    func updateMatchesFS() {
        let userRef = db.collection("users").document(name)
        userRef.updateData([
            "matches": [name: ], //fixme
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document sucessfully updated")
            }
        }
    }
 
}

class match {
    var id: String
    var userA: user
    var userB: user
    var date: Date
    var score: Int
    var topTracks: [String]
    var topArtists: [String]
    
    init(userA: user, userB: user) {
        
        
        
        self.id = userA.name + userB.name
        self.userA = userA
        self.userB = userB
        self.date = Date()
        generateScoresFor(self, userA, userB)
    }
    
}
