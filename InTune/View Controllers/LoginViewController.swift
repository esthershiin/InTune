//
//  LoginViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class LoginViewController: UIViewController, SPTSessionManagerDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // invoke auth modal
        let requestedScopes: SPTScope = [.appRemoteControl, .userTopRead, .playlistModifyPublic]
            self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        if (self.sessionManager.session != nil) {
            var vc = UITabBarController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }

    // implement session delegate
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
      print("success", session)
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
      print("fail", error)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
      print("renewed", session)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
