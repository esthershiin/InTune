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
        let requestedScopes: SPTScope = [.appRemoteControl, .userTopRead, .playlistModifyPublic]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        
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
        
    //    // instatiate SPTConfiguration
    //    let SpotifyClientID = "b29fa2b4649e4bc697ecbf6721edaa39"
    //    let SpotifyRedirectURL = URL(string: "localhost:8888/callback")!
    //
    //    lazy var configuration = SPTConfiguration(
    //      clientID: SpotifyClientID,
    //      redirectURL: SpotifyRedirectURL
    //    )

    // setup token swap
    lazy var sessionManager: SPTSessionManager = {
      if let tokenSwapURL = URL(string: "https://spotify-token-swap.glitch.me/api/token"),
         let tokenRefreshURL = URL(string: "https://spotify-token-swap.glitch.me/api/refresh_token") {
        self.configuration.tokenSwapURL = tokenSwapURL
        self.configuration.tokenRefreshURL = tokenRefreshURL
        self.configuration.playURI = ""
        storeTokens()
      }
      let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
      return manager
    }()
    
    // configure auth callback
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      self.sessionManager.application(app, open: url, options: options)
      return true
    }
    
    func storeTokens() {
        let _ = URLSession.shared.dataTask(with: self.configuration.tokenSwapURL!) { (data, response, err) in
            guard let tokenData = data else { return }
            let jsonTokenData = try? JSONSerialization.jsonObject(with: tokenData, options: [])
            guard let dictionary = jsonTokenData as? [String: Any] else { return }
            guard let access_token = dictionary["access_token"] else { return }
            guard let expires_in = dictionary["expires_in"] else { return }
            guard let refresh_token = dictionary["refresh_token"] else { return }
            guard let scope = dictionary["scope"] else { return }
            
            authToken = access_token as! String
            refreshToken = refresh_token as! String
        }.resume()
        
    }

}
