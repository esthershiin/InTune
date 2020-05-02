//
//  MatchViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class MatchViewController: UIViewController {
    
    var thisMatch: match!

    override func viewDidLoad() {
        super.viewDidLoad()
        usersLabel.text = "\(thisMatch.userA.name) + \(thisMatch.userB.name)"
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var matchScore: UILabel!
    @IBOutlet weak var matchMessage: UILabel!
    
    @IBOutlet weak var topSongImage1: UIImageView!
    @IBOutlet weak var topSongTitle1: UILabel!
    @IBOutlet weak var topSongImage2: UIImageView!
    @IBOutlet weak var topSongImage3: UIImageView!
    @IBOutlet weak var topSongTitle3: UILabel!
    @IBOutlet weak var topSongTitle2: UILabel!
    @IBOutlet weak var topArtist1: UILabel!
    @IBOutlet weak var topArtist2: UILabel!
    @IBOutlet weak var topArtist3: UILabel!
    @IBAction func goToPlaylist(_ sender: Any) {
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
