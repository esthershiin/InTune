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

class Tuner: NSURLConnection {

    func generateScoresFor(_ userA: user, _ userB: user) -> (tracks: [String], artists: [String], score: Int) {
        //filler
        
        return ([""], [""], 3)
    }

    func getArtistsJSON(_ user: user) {
        let urlStringArtists = "https://api.spotify.com/v1/me/top/artists?limit=50"
        guard let urlArtists = URL(string: urlStringArtists) else {return}
        var requestArtists = URLRequest(url: urlArtists)
        requestArtists.httpMethod = "GET"
        requestArtists.setValue(authToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: requestArtists) {(data, response, error) in
            
        }
    }

    func getTracksJSON(_ user: user) {
        let urlStringTracks = "https://api.spotify.com/v1/me/top/tracks?limit=50"
        guard let urlTracks = URL(string: urlStringTracks) else {return}
        var requestTracks = URLRequest(url: urlTracks)
        requestTracks.httpMethod = "GET"
        requestTracks.setValue(authToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: requestTracks) {(data, response, error) in
            guard let tracks = data else {
                guard let err = error else {
                    
                    return
                }
                
            }
        }
    }

}
