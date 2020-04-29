//
//  UserData.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

/* Notes for development: Will probably need an abstraction for a user (class or struct?). The class will need a username, name, date joined, top match, average match score, and maybe a data structure that holds all the matches. */

import Foundation
import SpotifyiOS

var isLoggedIn: Bool = true

let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"

//should the redirectURL be a custom url? should it be a universal link? could it be localhost? on the spotify developers page and in the plist i temporarily listed it as localhost:8888/callback 
let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

lazy var configuration = SPTConfiguration(
  clientID: SpotifyClientID,
  redirectURL: SpotifyRedirectURL
)

let tokenSwapURLString = "https://spotify-token-swap.glitch.me/api/token"
guard let tokenSwapURL = URL(string: tokenSwapURLString) else {return}

URLSession.shared.dataTask(with: url) { (data, response, err) in
    guard let tokenData = data else { return }
    let jsonTokenData = try? JSONSerialization.jsonObject(with: userData, options: [])
    guard let dictionary = jsonTokenData as? [String: Any] else { return }
    guard let access_token = dictionary["access_token"] else { return }
    guard let expires_in = dictionary["expires_in"] else { return }
    guard let refresh_token = dictionary["refresh_token"] else { return }
    guard let scope = dictionary["scope"] else { return }
}.resume()

