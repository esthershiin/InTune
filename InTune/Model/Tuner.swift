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
    
    var userA: user
    var userB: user
    var tracksA: [String]
    var tracksB: [String]
    var artistsA: [String]
    var artistsB: [String]
    var score: Int
    var topTracks: [String]
    var topArtists: [String]
    
    init(_ userA: user, _ userB: user) {
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
        for track in tracksA {
            if tracksB.contains(track) {
                tracksIntersection.append(track)
            }
        }
        for artist in artistsA {
            if artistsB.contains(artist) {
                artistsIntersection.append(artist)
            }
        }
        self.topTracks = tracksIntersection
        self.topArtists = artistsIntersection
        let totalIntersection = tracksIntersection.count + artistsIntersection.count
        self.score = (totalIntersection * 100) / (tracksA.count + artistsA.count)
        return (self.topTracks, self.topArtists, self.score)
    }
        
        
        
    func setTracks(to trackdata: [[String: Any]], for user: user) {
        
    }
    
    func getTracks(_ user: user) {
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

    func getArtists(_ user: user) {
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
