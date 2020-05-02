//
//  SearchHitViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  The search hit is what comes up if a user successfully searches another
    user by their name/ID. This is where a user may choose to interact with
    the user their search hit landed on. THIS FILE IS INCOMPLETE. */

import UIKit

class SearchHitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    
    @IBAction func tuneInAccepted(_ sender: Any) {
        performSegue(withIdentifier: "searchHitToMatch", sender: usernameLabel.text)
    }
    @IBAction func tuneInRejected(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let thisuser = currentUser else { return }
        if let identifier = segue.identifier {
            if let dest = segue.destination as? MatchViewController, let username = usernameLabel.text {
                //fix title and change other items
                dest.usersLabel.text = thisuser.name + " and " + username
            }
        }
    }

}
