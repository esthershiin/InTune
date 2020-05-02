//
//  DashboardViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let thisuser = currentUser else { return 0 }
        if (collectionView.tag == 0) {
            return thisuser.incomings.count
        } else if (collectionView.tag == 1) {
            return thisuser.outgoings.count
        } else if (collectionView.tag == 2) {
            return thisuser.numMatches
        } else {return 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userA = currentUser else {return UICollectionViewCell()}
        var userB = userA.incomings[indexPath.row]
        if (collectionView.tag == 1) {
            userB = userA.outgoings[indexPath.row]
        } else if (collectionView.tag == 2) {
            var thismatch = fetchMatch(id: userA.matches[indexPath.row])
            if (userA.name == thismatch.userA.name) {
                userB = thismatch.userB
            } else {
                userB = thismatch.userA
            }
        }
        let cell = MatchCollectionViewCell()
        let imageurlstring = "https://api.spotify.com/v1/users/\(userB.name)"
        guard let imageURL = URL(string: imageurlstring) else {return UICollectionViewCell()}
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
                    cell.MatchedUserImage.image = image
                }
            }
        }.resume()
        cell.MatchedUserName.text = userB.name
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        incomingRequests.delegate = self
        incomingRequests.dataSource = self
        pendingRequests.delegate = self
        pendingRequests.dataSource = self
        Matches.delegate = self
        Matches.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var incomingRequests: UICollectionView!
    
    @IBOutlet weak var pendingRequests: UICollectionView!
    
    @IBOutlet weak var Matches: UICollectionView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
