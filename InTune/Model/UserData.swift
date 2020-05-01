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
        let evaluation = generateScoresFor(userA, userB)
        self.score = evaluation.score
        self.topTracks = evaluation.tracks
        self.topArtists = evaluation.artists
    }
}
