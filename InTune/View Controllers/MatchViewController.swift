//
//  MatchViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//
/*  This is where a user can see the details of their match with another
    user. Matches are uniquely identified by their date and the users involved. */

import UIKit

class MatchViewController: UIViewController {
    
    var thisMatch: match!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersLabel.text = "\(thisMatch.userA) + \(thisMatch.userB)"
        matchScore.text = String(thisMatch.score)
        matchMessage.text = getMessage(score: thisMatch.score)
        
        var topsongsNames = [String]()
        var trackimages = [UIImage]()
        let trackID1 = thisMatch.topTracks[0]
        let trackID2 = thisMatch.topTracks[1]
        let trackID3 = thisMatch.topTracks[2]
        
        var topartistsNames = [String]()
        let artistID1 = thisMatch.topArtists[0]
        let artistID2 = thisMatch.topArtists[1]
        let artistID3 = thisMatch.topArtists[2]
        
        guard let tracksURL = URL(string: "https://api.spotify.com/v1/tracks/?ids=\(trackID1),\(trackID2),\(trackID3)") else {return}
        var req = URLRequest(url: tracksURL)
        req.httpMethod = "GET"
        req.addValue(authToken!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) {(data, response, err) in
            guard let tracks = data else {return}
            let tracksjson = try? JSONSerialization.jsonObject(with: tracks, options: [])
            guard let dict = tracksjson as? [String: Any] else {return}
            let threetracks = dict["tracks"] as! [[String: Any]]
            for n in 0...2 {
                topsongsNames[n] = threetracks[n]["name"] as! String
                let album = threetracks[n]["album"] as! [String: Any]
                let imageURLstr = album["images"] as! String
                guard let imageURL = URL(string: imageURLstr) else {return}
                
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        trackimages[n] = image!
                    }
                }
            }
        }
        
        guard let artistsURL = URL(string: "https://api.spotify.com/v1/artists/?ids=\(artistID1),\(artistID2),\(artistID3)") else {return}
        var artistsReq = URLRequest(url: artistsURL)
        artistsReq.httpMethod = "GET"
        artistsReq.addValue(authToken!, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) {(data, response, err) in
            guard let artists = data else {return}
            let artistsjson = try? JSONSerialization.jsonObject(with: artists, options: [])
            guard let dict = artistsjson as? [String: Any] else {return}
            let threetracks = dict["artists"] as! [[String: Any]]
            for n in 0...2 {
                topartistsNames[n] = threetracks[n]["name"] as! String
            }
        }
        
        topSongTitle1.text = topsongsNames[0]
        topSongTitle2.text = topsongsNames[1]
        topSongTitle3.text = topsongsNames[2]
        
        topSongImage1.image = trackimages[0]
        topSongImage2.image = trackimages[1]
        topSongImage3.image = trackimages[2]
        
        topArtist1.text = topartistsNames[0]
        topArtist2.text = topartistsNames[1]
        topArtist3.text = topartistsNames[2]
    }
    
    @IBAction func goToPlaylist(_ sender: Any) {
    }
    
}
