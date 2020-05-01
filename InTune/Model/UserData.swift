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
var isLoggedIn: Bool = false
var authToken: String = ""
var refreshToken: String = ""

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
    }
    
    //remove a request (decline request?)
    func removeRequest(otherUser: user) {
        removeUser(arr: incomings, other: otherUser)
        removeUser(arr: otherUser.outgoings, other: self)
    }
    
    //accept an incoming request and update the other user's status
    func acceptRequest(otherUser: user) {
        addMatch(other: otherUser)
        otherUser.addMatch(other: self)
        removeRequest(otherUser: otherUser)
    }
    
    //add a match
    func addMatch(other: user) {
        let newMatch = match(userA: self, userB: other)
        avgScore = (avgScore * numMatches + newMatch.score) / (numMatches + 1)
        numMatches += 1
        matches.append(newMatch)
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
    
    //adding user data to Firestore
    func addUser() {
        
        var outgoingUsernames = [String]()
        for outUser in outgoings {
            outgoingUsernames.append(outUser.name)
        }
        
        var incomingUsernames = [String]()
        for inUser in incomings {
            incomingUsernames.append(inUser.name)
        }
        
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "name": name,
            "avgScore": avgScore,
            "numMatches": numMatches,
            "matches": matches, //fixme
            "outgoings": outgoingUsernames,
            "incomings": incomingUsernames,
        ]) {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
 
}

class match {
    var userA: user
    var userB: user
    var date: Date
    var score: Int
    var topTracks: [String]
    var topArtists: [String]
    
    init(userA: user, userB: user) {
        self.userA = userA
        self.userB = userB
        self.date = Date()
        let evaluation = Tuner.generateScoresFor(userA, userB)
        self.score = evaluation.score
        self.topTracks = evaluation.tracks
        self.topArtists = evaluation.artists
    }
}
