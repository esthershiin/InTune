//
//  UserData.swift
//  InTune
//
//  Created by Allyson, Esther, Junna on 4/23/20.
//
/*  UserData contains the definitions for the user class and the match class.
    It also contains the relevant data for the current user, including their tokens
    and whether or not they're logged in. UserData also interacts with Firebase,
    where our user and match database is stored. */

import Foundation
import Firebase

//Firebase reference
let db = Firestore.firestore()

//authtoken and refresh token must be persistent
var authToken: String? = "BQACMdfFoH3GfFYs10LMODkwzKxYYa3vAkDlrDZRKdPMKuXlgrgxwzHkCSd8HT8TRNeOAzDAfZn20Agz-n8Zl6jvMVfdvgEtpX_QjkIL7uFlnOOCKoCMsV5rALEe_E10ESwBDB8X1OHT-KwZIewxEPqoYxL11FWPykYa7rfe6mN2zzSRFs9YpaGnRwK36WM23fnagjxVG7dnwJVOMVqdaYW8rN4mnlMmog"
var refreshToken: String?
var isLoggedIn: Bool = false
var authcode: String?

var currentUser: user?

class user {
    var name: String
    var avgScore: Int
    var numMatches: Int
    var outgoings = [String]()
    var incomings = [String]()
    var matches = [String]()
    var startDate: Date
    var topScore: Int
    var topMatch: String
    
    init(name: String) {
        self.name = name
        avgScore = 0
        numMatches = 0
        outgoings = [String]()
        incomings = [String]()
        matches = [String]()
        startDate = Date()
        topScore = 0
        topMatch = "No matches found."
        //if user is new create new collection in firestore
        let docRef = db.collection("users").document(name)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("User \(name) has logged in before.")
            } else {
                self.addNewUser()
            }
        }
    }
    
    //request a user
    func requestUser(otherUser: String) {
        //update userA outgoings
        outgoings.append(otherUser)
        update(username:self.name, data: "outgoings", newData: self.outgoings)
        //update userB incomings
        var otherIncomings = fetch(username: otherUser, data: "incomings") as! [String]
        otherIncomings.append(self.name)
        update(username: otherUser, data: "incomings", newData: otherIncomings)
    }
    
    //remove a request (decline request)
    func removeRequest(otherUser: String) {
        //update userA incomings
        for (i, user) in self.incomings.enumerated() {
            if (user == otherUser) {
                self.incomings.remove(at: i)
                break
            }
        }
        update(username: self.name, data: "incomings", newData: self.incomings)
        //update userB outgoings
        var otherOutgoings = fetch(username: otherUser, data: "outgoings") as! [String]
        for (i, user) in otherOutgoings.enumerated() {
            if (user == self.name) {
                otherOutgoings.remove(at: i)
                break
            }
        }
        update(username: otherUser, data: "outgoings", newData: otherOutgoings)
    }
    
    //accept an incoming request
    func acceptRequest(otherUser: String) {
        addMatch(other: otherUser)
        removeRequest(otherUser: otherUser)
    }
    
    //add a match
    func addMatch(other: String) {
        let newMatch = match(userA: self.name, userB: other)
        newMatch.addNewMatch()
        avgScore = (avgScore * numMatches + newMatch.score) / (numMatches + 1)
        numMatches += 1
        matches.append(newMatch.id)
        //update matches
        update(username: self.name, data: "matches", newData: other)
        var otherMatches = fetch(username: other, data: "matches") as! [String]
        otherMatches.append(self.name)
        update(username: other, data: "matches", newData: otherMatches)
        //update numMatches
        update(username: self.name, data: "numMatches", newData: self.numMatches)
        let otherNumMatches = (fetch(username: other, data: "numMatches") as! Int) + 1
        update(username: other, data: "numMatches", newData: otherNumMatches)
        //update avgScores
        update(username: self.name, data: "avgScore", newData: numMatches)
        var otherAvgScore = fetch(username: other, data: "avgScore") as! Int
        otherAvgScore = (otherAvgScore * otherNumMatches + newMatch.score) / (otherNumMatches + 1)
        update(username: self.name, data: "avgScore", newData: otherAvgScore)
        //update topScore and topMatch
        if (self.topScore < newMatch.score) {
            self.topScore = newMatch.score
            self.topMatch = other
            update(username: self.name, data: "topScore", newData: self.topScore)
            update(username: self.name, data: "topMatch", newData: self.topMatch)
        }
        let otherTopScore = fetch(username: other, data: "topScore") as! Int
        if (otherTopScore < newMatch.score) {
            update(username: other, data: "topScore", newData: newMatch.score)
            update(username: other, data: "topMatch", newData: self.name)
        }
        
    }
    
    //add new user data to Firestore
    func addNewUser() {
        db.collection("users").document(name).setData([
            "avgScore": avgScore,
            "numMatches": numMatches,
            "matches": matches,
            "outgoings": outgoings,
            "incomings": incomings,
            "startDate": startDate,
            "topScore": topScore,
            "topMatch": topMatch
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written")
            }
        }
    }
    
}


class match {
    var userA: String
    var userB: String
    var date: Date
    var score: Int
    var topTracks: [String]
    var topArtists: [String]
    var id: String
    
    init(userA: String, userB: String) {
        self.userA = userA
        self.userB = userB
        self.date = Date()
        
        let myTuner = Tuner(userA, userB)
        self.score = myTuner.score
        
        self.topTracks = myTuner.topTracks
        self.topArtists = myTuner.topArtists

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        self.id = "@" + userA + "@" + userB + formatter.string(from: date)
        
        //if user is new create new collection in firestore
        let docRef = db.collection("matches").document(self.id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Match \(self.id) already added.")
            } else {
                self.addNewMatch()
            }
        }
    }
    
    func addNewMatch() {
        db.collection("matches").document(id).setData([
            "userA": userA,
            "userB": userB,
            "date": date,
            "score": score,
            "topTracks": topTracks,
            "topArtists": topArtists,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written")
            }
        }
    }
    
}

//Firestore

//fetch user data from firestore
func fetch(username: String, data: String) -> Any {
    var docData: Any!
    let docRef = db.collection("users").document(username)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            docData = document.data()?[data] as Any
        } else {
            print("Document does not exist")
        }
    }
    return docData!
}

//fetch current user
func fetchUser(username: String) {
    let currUser = user(name: username)
    currUser.avgScore = fetch(username: username, data: "avgScore") as! Int
    currUser.numMatches = fetch(username: username, data: "numMatches") as! Int
    currUser.outgoings = fetch(username: username, data: "outgoings") as! [String]
    currUser.incomings = fetch(username: username, data: "incomings") as! [String]
    currUser.matches = fetch(username: username, data: "matches") as! [String]
    currUser.startDate = fetch(username: username, data: "startDate") as! Date
    currUser.topScore = fetch(username: username, data: "topScore") as! Int
    currUser.topMatch = fetch(username: username, data: "topMatch") as! String
    currentUser = currUser
}

//fetch current user
func fetchOtherUser(username: String) -> user {
    let currUser = user(name: username)
    currUser.avgScore = fetch(username: username, data: "avgScore") as! Int
    currUser.numMatches = fetch(username: username, data: "numMatches") as! Int
    currUser.outgoings = fetch(username: username, data: "outgoings") as! [String]
    currUser.incomings = fetch(username: username, data: "incomings") as! [String]
    currUser.matches = fetch(username: username, data: "matches") as! [String]
    currUser.startDate = fetch(username: username, data: "startDate") as! Date
    currUser.topScore = fetch(username: username, data: "topScore") as! Int
    currUser.topMatch = fetch(username: username, data: "topMatch") as! String
    return currUser
}

//update user data in firestore
func update(username: String, data: String, newData: Any) {
    let userRef = db.collection("users").document(username)
    userRef.updateData([data: newData]) { err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("Document successfully updated")
        }
    }
}

//fetch match data from firestore
func fetch(matchID: String, data: String) -> Any {
    var docData: Any!
    let docRef = db.collection("matches").document(matchID)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            docData = document.data()?[data] as Any
        } else {
            print("Document does not exist")
        }
    }
    return docData!
}

//fetch match
func fetchMatch(id: String) -> match {
    let targetUserA = fetch(matchID: id, data: "userA") as! String
    let targetUserB = fetch(matchID: id, data: "userB") as! String
    let targetMatch = match(userA: targetUserA, userB: targetUserB)
    targetMatch.date = fetch(matchID: id, data: "date") as! Date
    targetMatch.score = fetch(matchID: id, data: "score") as! Int
    targetMatch.topTracks = fetch(matchID: id, data: "topTracks") as! [String]
    targetMatch.topArtists = fetch(matchID: id, data: "topArtists") as! [String]
    return targetMatch
}
