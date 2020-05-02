//
//  IncomingRequestViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class IncomingRequestViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var requestingUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
