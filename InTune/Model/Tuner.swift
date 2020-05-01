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
        var tracksA = getTracks(userA)
        var tracksB = getTracks(userB)
        var artistsA = getArtists(userA)
        var artistsB = getArtists(userB)
        
        var tracksIntersection = []
        var artistsIntersection = []
        var genreIntersection = []
        
        return ([""], [""], 3)
    }
    
    func getTracks(_ user: user) -> [[[String: Any]]]{
        let urlStringTracks = "https://api.spotify.com/v1/me/top/tracks?limit=50"
        guard let urlTracks = URL(string: urlStringTracks) else {return nil}
        var requestTracks = URLRequest(url: urlTracks)
        requestTracks.httpMethod = "GET"
        requestTracks.setValue(authToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: requestTracks) {(data, response, error) in
            if error != nil {
                print(error!)
            } else {
                guard let tracks = data else { return nil }
                let json = try? JSONSerialization.jsonObject(with: tracks, options: [])
                guard let dict = json as? [String: Any] else { return nil }
                guard let topTracks = dict["items"] else { return nil }
                return topTracks
            }

        }.resume()
    }

    func getArtists(_ user: user) -> [[[String: Any]]]? {
        let urlStringArtists = "https://api.spotify.com/v1/me/top/artists?limit=50"
        guard let urlArtists = URL(string: urlStringArtists) else {return nil}
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
                guard let artists = data else { return nil }
                let json = try? JSONSerialization.jsonObject(with: artists, options: [])
                guard let dict = json as? [String: Any] else { return nil }
                guard let topArtists = dict["items"] else { return nil }
                return topArtists
            }
        }.resume()
    }

}
