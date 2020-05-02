//
//  DashboardViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  The Dashboard is the users center for all matches: prior, incoming, and
    outgoing. The dashboard is where the user can see who has requested them,
    check up on the people they've requested, browse old matches, and search
    for new people to tune in with. */

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var incomingRequests: UICollectionView!
    
    @IBOutlet weak var pendingRequests: UICollectionView!
    
    @IBOutlet weak var Matches: UICollectionView!
    
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
        
        let cell = MatchCollectionViewCell()
        
        var userB = userA.incomings[indexPath.row]
        if (collectionView.tag == 1) {
            userB = userA.outgoings[indexPath.row]
        } else if (collectionView.tag == 2) {
            let thismatch = fetchMatch(id: userA.matches[indexPath.row])
            cell.mymatch = thismatch
            if (userA.name == thismatch.userA) {
                userB = thismatch.userB
            } else {
                userB = thismatch.userA
            }
        }
        let imageurlstring = "https://api.spotify.com/v1/users/\(userB)"
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
        cell.MatchedUserName.text = userB
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.tag == 0) {
            performSegue(withIdentifier: "dashboardToIncoming", sender: collectionView.cellForItem(at: indexPath))
        } else if (collectionView.tag == 1) {
            performSegue(withIdentifier: "dashboardToOutgoing", sender: collectionView.cellForItem(at: indexPath))
        } else if (collectionView.tag == 2) {
            performSegue(withIdentifier: "dashboardToMatch", sender: collectionView.cellForItem(at: indexPath))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dashboardToIncoming") {
            guard let dest = segue.destination as? IncomingRequestViewController else {return}
            guard let cell = sender as? MatchCollectionViewCell else {return}
            dest.requestingUserName = cell.MatchedUserName.text
        } else if (segue.identifier == "dashboardToOutgoing") {
            guard let dest = segue.destination as? OutgoingRequestViewController else { return }
            guard let cell = sender as? MatchCollectionViewCell else {return}
            dest.pendingUserName = cell.MatchedUserName.text
        } else {
            guard let dest = segue.destination as? MatchViewController else {return}
            guard let cell = sender as? MatchCollectionViewCell else {return}
            dest.thisMatch = cell.mymatch
        }
    }

}
