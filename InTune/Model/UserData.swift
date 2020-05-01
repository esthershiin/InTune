//
//  UserData.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

/* Notes for development: Will probably need an abstraction for a user (class or struct?). The class will need a username, name, date joined, top match, average match score, and maybe a data structure that holds all the matches. */

import Foundation

//authtoken and refresh token must be persistent
var isLoggedIn: Bool = false
var authToken: String = ""
var refreshToken: String = ""
var tokenRefreshURL = URL(string: "https://spotify-token-swap.glitch.me/api/refresh_token")

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


