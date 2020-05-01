//
//  Tuner.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
//  Tuner contains the logic to generate compability
//  data between two users. It accesses the Spotify user
//  data for both users–specifically their top tracks and
//  top artists over the past 6 months. It uses the Spotify
//  API to do so. 

import Foundation

func generateScoresFor(_ userA: user, _ userB: user) -> (tracks: [String], artists: [String], score: Int) {
    //filler
    
    return ([""], [""], 3)
}

func getJSON(_ user: user) {
    var urlString = "https://api.spotify.com/v1/me"
    
}
