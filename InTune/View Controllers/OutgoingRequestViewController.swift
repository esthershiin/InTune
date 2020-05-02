//
//  OutgoingRequestViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  If the current user has requested to match another user, but the other
    user has not yet responded, the request will show up as a part of the
    outgoing requests. */

import UIKit

class OutgoingRequestViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    var pendingUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var requested = fetchOtherUser(username: pendingUserName!)
        joinDateLabel.text = formatter.string(from: requested.startDate)
        usernameLabel.text = requested.name
        
        guard let profileURL = URL(string: "https://api.spotify.com/v1/users/\(requested.name)") else {return}
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
    
    @IBAction func returnToMatches(_ sender: Any) {
    }

}
