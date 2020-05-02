//
//  Constants.swift
//  InTune
//
//  Created by Allyson on 4/30/20.
//

import Foundation

//let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"
//
//let SpotifyRedirectURL = URL(string: "intune-login://callback")!
//
//let configuration = SPTConfiguration(
//  clientID: SpotifyClientID,
//  redirectURL: SpotifyRedirectURL
//)
//


let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"

let SpotifyRedirectURI = "spotify-ios-quick-start://spotify-login-callback"

let SpotifyRedirectURL = URL(string: SpotifyRedirectURI)!

let tokenRefreshURL = URL(string: "https://spotify-token-swap.glitch.me/api/refresh_token")

