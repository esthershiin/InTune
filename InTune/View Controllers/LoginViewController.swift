//
//  LoginViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class LoginViewController: UIViewController, SPTSessionManagerDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
//        let requestedScopes: SPTScope = [.appRemoteControl, .userTopRead, .playlistModifyPublic]
        
//        let urlstr = "https://accounts.spotify.com/authorize?client_id=\(SpotifyClientID)&return_type=code&redirect_uri=\(SpotifyRedirectURI)&scopes=\(requestedScopes)"
//
//        guard let myurl = URL(string: urlstr) else {return}
//
//        URLSession.shared.dataTask(with: myurl) {(data, response, err) in
//            guard let content = data else {return}
//            let json = try? JSONSerialization.jsonObject(with: content, options: [])
//            guard let dict = json as? [String: Any] else {return}
//            authcode = dict["code"] as? String
//        }
        
//        guard let tokenSwapURL = URL(string: "https://spotify-token-swap.glitch.me/api/token?code=\(authcode)") else { return }
//            URLSession.shared.dataTask(with: tokenSwapURL) {(data, response, err) in
//            guard let tokens = data else {return}
//            let json = try? JSONSerialization.jsonObject(with: tokens, options: [])
//            guard let dict = json as? [String: Any] else {return}
//            authToken = dict["access_token"] as? String
//            refreshToken = dict["refresh_token"] as? String
//        }

        if (isLoggedIn) {
            var vc = UITabBarController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
