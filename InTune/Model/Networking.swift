//
//  Networking.swift
//  InTune
//
//  Created by Allyson on 5/1/20.
//

import Foundation

func useRefreshToken() {
    var urlstr = "https://spotify-token-swap.glitch.me/api/refresh_token?refresh_token=" + refreshToken
    guard let refreshURL = URL(string: urlstr) else {return}
    var req = URLRequest(url: refreshURL)
    req.httpMethod = "POST"
    req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: req) {(data, response, err) in
        guard let tokenData = data else {return}
        let json = try? JSONSerialization.jsonObject(with: tokenData, options: [])
        guard let dict = json as? [String: Any] else {return}
        guard let newToken = dict["access_token"] as? String else {return}
        authToken = newToken
    }
}
