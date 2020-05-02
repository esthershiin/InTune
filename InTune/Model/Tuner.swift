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
    var artistsA: [String: String]
    var artistsB: [String: String]
    var score: Int
    var topTracks: [String]
    var topArtists: [String]
    
    init(_ userA: String, _ userB: String) {
        self.userA = userA
        self.userB = userB
        tracksA = [""]
        tracksB = [""]
        artistsA = ["": ""]
        artistsB = ["": ""]
        score = 0
        topTracks = [""]
        topArtists = [""]
    }

    func generateScores() -> (tracks: [String], artists: [String], score: Int) {
        var genresIntersection = [String]()
        var tracksIntersection = [String]()
        var artistsIntersection = [String]()
        for track in tracksA {
            if tracksB.contains(track) {
                tracksIntersection.append(track)
            }
        }
        for (artist, genre) in artistsA {
            if (artistsB.keys.contains(artist)) {
                artistsIntersection.append(artist)
            }
            if (artistsB.values.contains(genre)) {
                genresIntersection.append(genre)
            }
        }
        self.topTracks = tracksIntersection
        self.topArtists = artistsIntersection
        let totalIntersection = tracksIntersection.count + artistsIntersection.count + genresIntersection.count
        let numArtist = max(artistsA.count, artistsB.count)
        let numTracks = max(tracksA.count, tracksB.count)
        self.score = (totalIntersection * 100) / (numTracks + (2 * numArtist))
        return (self.topTracks, self.topArtists, self.score)
    }
        
        
        
    func setTracks(to trackdata: [[String: Any]], for user: String) {
        if (userA == user) {
            for item in trackdata {
                guard let trackTitle = item["id"] as? String else {return}
                tracksA.append(trackTitle)
            }
        } else {
            for item in trackdata {
                guard let trackTitle = item["id"] as? String else {return}
                tracksB.append(trackTitle)
            }
        }
    }
    
    func setArtists(to artistdata: [[String: Any]], for user: String) {
        if (userA == user) {
            for item in artistdata {
                guard let artist = item["id"] as? String , let genre = item["genres"] as? String else {return}
                artistsA[artist] = genre
            }
        } else {
            for item in artistdata {
                guard let artist = item["id"] as? String , let genre = item["genres"] as? String else {return}
                artistsB[artist] = genre
            }
        }
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
                self.setArtists(to: topArtists as! [[String : Any]], for: user)
            }
        }.resume()
    }

    
}
