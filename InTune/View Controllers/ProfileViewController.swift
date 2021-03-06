//
//  ProfileViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  The Profile is the users own information, which gives stats on the users
    overall match data. This is also where users can log out if they wish to. */

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var topMatchLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var numberOfMatchesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = currentUser else {return}
        
        usernameLabel.text = user.name
        joinedDateLabel.text = formatter.string(from: user.startDate)
        if (user.topMatch == "No matches found.") {
            topMatchLabel.text = user.topMatch
        } else {
            topMatchLabel.text = "\(user.topScore) with @\(user.topMatch)"
        }
        averageScoreLabel.text = String(user.avgScore)
        numberOfMatchesLabel.text = String(user.matches.count)
        
        let imageurlstring = "https://api.spotify.com/v1/users/\(user.name)"
        guard let imageURL = URL(string: imageurlstring) else {return}
        var req = URLRequest(url: imageURL)
        req.httpMethod = "GET"
        req.addValue(authToken!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) {(data, response, err) in
            guard let profile = data else {return}
            let profilejson = try? JSONSerialization.jsonObject(with: profile, options: [])
            guard let profiledict = profilejson as? [String: Any] else { return}
            guard let pfp = profiledict["images"] as? [String: Any] else { return}
            guard let pfpurl = pfp["url"] as? String else {return}
            guard let imageURL = URL(string: pfpurl) else {return}

            // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }.resume()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        currentUser = nil
        isLoggedIn = false
        authToken = ""
        refreshToken = ""
        performSegue(withIdentifier: "loggingOut", sender: self)
    }

}
