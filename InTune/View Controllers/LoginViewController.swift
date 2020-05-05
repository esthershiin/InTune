//
//  LoginViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  The Login page is where users will start off if they've never logged in before,
    or if their refresh token has expired and they must renew their session. */

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* Upon login button press, initiate a Spotify session using the
     Auth code flow. Once the session has been initiated, segue to the
    main portion of the app, which corresponds to the tab bar. */
    @IBAction func loginButtonPressed(_ sender: Any) {
//        let group = DispatchGroup()
//        group.enter()
        

//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.requestSpotify()
//            group.leave()
        
        guard let userurl = URL(string: "https://api.spotify.com/v1/me") else {return}
        var userreq = URLRequest(url: userurl)
        userreq.httpMethod = "GET"
        userreq.addValue("Bearer: \(authToken!)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: userreq) {(data, response, err) in
            guard let profile = data else {return}
            let json = try? JSONSerialization.jsonObject(with: profile, options: [])
            guard let dict = json as? [String: Any] else {return}
            guard let username = dict["id"] as? String else {return}
            currentUser = user(name: username)
        }.resume()
        
        if (currentUser != nil) {
            self.performSegue(withIdentifier: "LoginToTab", sender: self)
        }
        
    }
}
