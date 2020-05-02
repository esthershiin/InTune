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
        
        // invoke auth modal
        let requestedScopes: SPTScope = [.userTopRead, .playlistModifyPublic]
        manager = sessionManager
        manager.initiateSession(with: requestedScopes, options: .default)
        if (refreshToken != nil) {
            isLoggedIn = true
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // implement session delegate
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
      print("success", session)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
      print("fail", error)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
      print("renewed", session)
    }

    let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"
    
    var manager: SPTSessionManager!

    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    // setup token swap
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
    
    func getCode(){
        let urlstr = "https://accounts.spotify.com/authorize?client_id=\(SpotifyClientID)&response_type=code&redirect_uri=\(SpotifyRedirectURI)&scopes=user-top-read+playlist-modify-public"
        guard let myurl = URL(string: urlstr) else {return}
        URLSession.shared.dataTask(with: myurl) {(data, response, err) in
            guard let content = data else {return}
            let json = try? JSONSerialization.jsonObject(with: content, options: [])
            guard let dict = json as? [String: Any] else {return}
            authcode = dict["code"] as? String
        }.resume()
    }
    
    // configure auth callback
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      self.sessionManager.application(app, open: url, options: options)
      return true
    }
    
    func storeTokens() {
        authToken = manager.session?.accessToken
        refreshToken = manager.session?.refreshToken
    }
    
    func setIsLoggedIn() {
        var temp = manager.session?.isExpired ?? true
        isLoggedIn = !temp
    }

}
