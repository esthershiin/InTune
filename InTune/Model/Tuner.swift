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


class Tuner {
    
    var userA: String
    var userB: String
    var tracksA: [String]
    var tracksB: [String]
    var artistsA: [String]
    var artistsB: [String]
    var score: Int
    var topTracks: [String]
    var topArtists: [String]
    
    init(_ userA: String, _ userB: String) {
        self.userA = userA
        self.userB = userB
        tracksA = [""]
        tracksB = [""]
        artistsA = [""]
        artistsB = [""]
        score = 0
        topTracks = [""]
        topArtists = [""]
        
    }

    func generateScores() -> (tracks: [String], artists: [String], score: Int) {
        
        var tracksIntersection = [String]()
        var artistsIntersection = [String]()
        var genreIntersection = [String]()
        
        return ([""], [""], 3)
    }
        
        
        
    func setTracks(to trackdata: [[String: Any]], for user: String) {
        
    }
    
    func getTracks(_ user: String) {
        let urlStringTracks = "https://api.spotify.com/v1/me/top/tracks?limit=50"
        guard let urlTracks = URL(string: urlStringTracks) else {return}
        var requestTracks = URLRequest(url: urlTracks)
        requestTracks.httpMethod = "GET"
        requestTracks.setValue(authToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: requestTracks) {(data, response, error) in
            if error != nil {
                print(error!)
            } else {
                guard let tracks = data else { return}
                let json = try? JSONSerialization.jsonObject(with: tracks, options: [])
                guard let dict = json as? [String: Any] else {return}
                guard let topTracks = dict["items"] else {return}
                self.setTracks(to: topTracks as! [[String : Any]], for: user)
            }
        }.resume()
    }

    func getArtists(_ user: String) {
        let urlStringArtists = "https://api.spotify.com/v1/me/top/artists?limit=50"
        guard let urlArtists = URL(string: urlStringArtists) else {return}
        var requestArtists = URLRequest(url: urlArtists)
        requestArtists.httpMethod = "GET"
        requestArtists.setValue(authToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: requestArtists) {(data, response, err) in
            if let error = err {
                print(error)
                let code = error.localizedDescription
                if (code == "") {
                    useRefreshToken()
                }
            } else {
                guard let artists = data else { return}
                let json = try? JSONSerialization.jsonObject(with: artists, options: [])
                guard let dict = json as? [String: Any] else { return}
                guard let topArtists = dict["items"] else { return}
                self.setTracks(to: topArtists as! [[String : Any]], for: user)
            }
        }.resume()
    }

    
}
