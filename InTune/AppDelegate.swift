//
//  AppDelegate.swift
//  InTune
//
//  Created by Allyson Park, Esther Shin, Junna Chen on 4/21/20.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        requestCode()
        requestToken()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // Implement session delegate. If the session is successfully initiated,
    // save the relevant data. This includes the current user and tokens.
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        isLoggedIn = true
        guard let userurl = URL(string: "https://api.spotify.com/v1/me") else {return}
        let userreq = URLRequest(url: userurl)
        URLSession.shared.dataTask(with: userreq) {(data, response, closure) in
            guard let profile = data else {return}
            let json = try? JSONSerialization.jsonObject(with: profile, options: [])
            guard let dict = json as? [String: Any] else {return}
            guard let username = dict["id"] as? String else {return}
            currentUser = user(name: username)
        }
        authToken = session.accessToken
        refreshToken = session.refreshToken
        print("success", session)
    }
    
    // Upon session failure, there is no need to take action.
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    
    // Upon session renewal, also renew our copy of the AuthToken.
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        authToken = session.accessToken
        print("renewed", session)
    }

    let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"

    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    // Setup token swap using Glitch.
    lazy var sessionManager: SPTSessionManager = {
        
        if let tokenSwapURL = URL(string: "https://spotify-token-swap.glitch.me/api/token"),
        let tokenRefreshURL = URL(string: "https://spotify-token-swap.glitch.me/api/refresh_token") {
        self.configuration.tokenSwapURL = tokenSwapURL
        self.configuration.tokenRefreshURL = tokenRefreshURL
        self.configuration.playURI = ""
      }
      let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
      return manager
    }()
    
    // Request to open a session with Spotify. This should only be called by
    // the LoginViewController.
    func requestSpotify() {
        let requestedScopes: SPTScope = [.userTopRead, .playlistModifyPublic]
        sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    // Configure auth callback.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      self.sessionManager.application(app, open: url, options: options)
      return true
    }

}
