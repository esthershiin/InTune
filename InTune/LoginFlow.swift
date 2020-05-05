//
//  LoginFlow.swift
//  InTune
//
//  Created by Allyson on 5/3/20.
//

import Foundation

let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"

let SpotifyRedirectURLString =  "spotify-ios-quick-start://spotify-login-callback"

let SpotifyClientSecret = "531ed68afc6940ba9e7d6cee18e0d3f3"

func requestCode(){
    let urlstr = "https://accounts.spotify.com/authorize?client_id=\(SpotifyClientID)&response_type=code&redirect_uri=\(SpotifyRedirectURLString)&scope=user-top-read+playlist-modify-public"
    guard let myurl = URL(string: urlstr) else {return}
    
    var request = URLRequest(url: myurl)
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    URLSession.shared.dataTask(with: request) {(data, response, err) in
        guard let content = data else {return}
        let dataString = String(bytes: content, encoding: String.Encoding.utf8)
        print("data\(dataString)")
        var json: Any?
        do {
            let data = try JSONSerialization.jsonObject(with: content, options: [])
            
            guard let dict = data as? [String: Any] else {return}
            authcode = dict["code"] as? String
            print("authcode", authcode)
        } catch {
            print("JSON error", error.localizedDescription)
        }
        
    }.resume()
}

func requestToken() {
    guard let code = authcode else {return}
    let urlstr = "https://accounts.spotify.com/api/token?grant_type=authorization_code&code=\(authcode)&redirect_uri=\(SpotifyRedirectURLString)&client_id=\(SpotifyClientID)&client_secret=\(SpotifyClientSecret)"
    guard let url = URL(string: urlstr) else {return}
    var urlREQ = URLRequest(url: url)
    urlREQ.httpMethod = "POST"
    URLSession.shared.dataTask(with: urlREQ) {(data, response, err) in
        guard let data = data else { return }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = json as? [String: Any] else {return}
        authToken = dict["access_token"] as! String
        refreshToken = dict["refresh_token"] as! String
    }.resume()
}
