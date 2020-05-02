//
//  SearchHitViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class SearchHitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
