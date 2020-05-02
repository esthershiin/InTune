//
//  IncomingRequestViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  If a different user has requested to tune in with the current user, the
    current user may view their request on the Incoming Request page. They
    have the option to accept or decline. */

import UIKit

class IncomingRequestViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var requestingUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var requester = fetchOtherUser(username: requestingUserName!)
        joinDateLabel.text = formatter.string(from: requester.startDate)
        usernameLabel.text = requester.name
        
        guard let profileURL = URL(string: "https://api.spotify.com/v1/users/\(requester.name)") else {return}
        var req = URLRequest(url: profileURL)
        req.httpMethod = "GET"
        req.addValue(authToken!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) {(data, response, err) in
            guard let profile = data else { return}
            let profilejson = try? JSONSerialization.jsonObject(with: profile, options: [])
            guard let profiledict = profilejson as? [String: Any] else { return}
            guard let imagesArray = profiledict["images"] as? [[String: Any]] else { return}
            guard let pfpDict = imagesArray[0] as? [String: Any] else {return}
            guard let pfpUrl = pfpDict["url"] as? String else {return}
            guard let imageURL = URL(string: pfpUrl) else {return}

            // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
    }
    
    @IBAction func requestAccepted(_ sender: Any) {
        performSegue(withIdentifier: "requestToMatch", sender: usernameLabel.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let thisuser = currentUser else { return }
        if let identifier = segue.identifier {
            if let dest = segue.destination as? MatchViewController, let username = usernameLabel.text {
                //get match score
                var newMatch = match(userA: thisuser.name, userB: username)
                dest.thisMatch = newMatch
            }
        }
    }

    
    @IBAction func requestRejected(_ sender: Any) {
    }

}
