//
//  ProfileViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

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
        topMatchLabel.text = String(user.matches[0].score)
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
