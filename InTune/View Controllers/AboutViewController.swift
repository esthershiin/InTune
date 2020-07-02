//
//  AboutViewController.swift
//  InTune
//
//  Created by Allyson on 5/1/20.
//
/*  The About page is static. It contains information about the app and
    its usage. This custom ViewController class is included for the
    possibility of adding more functionality, such as settings or "share
    with friends" button. */

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    //create dynamic link on firebase -> link to app store to download InTune
    // https://firebase.google.com/docs/dynamic-links/use-cases/user-to-user
    
    lazy private var shareController: UIActivityViewController = {
      let activities: [Any] = [
        "Invite Your Friends",
        URL(string: "https://firebase.google.com")! //FIXME
      ]
      let controller = UIActivityViewController(activityItems: activities,
                                                applicationActivities: nil)
      return controller
    }()
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        let inviteController = UIStoryboard(name: "Main", bundle: nil)
          .instantiateViewController(withIdentifier: "InviteViewController")
        self.navigationController?.pushViewController(inviteController, animated: true)
    }
}
