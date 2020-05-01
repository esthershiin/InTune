//
//  IncomingRequestViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class IncomingRequestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func requestAccepted(_ sender: Any) {
        performSegue(withIdentifier: "requestToMatch", sender: usernameLabel.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let dest = segue.destination as? MatchViewController, let username = usernameLabel.text {
                //fix title and change other items
                dest.usersLabel.text = "Match with " + username
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
