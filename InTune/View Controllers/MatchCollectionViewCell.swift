//
//  OutgoingCollectionViewCell.swift
//  InTune
//
//  Created by Allyson on 5/1/20.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell {
    
    var mymatch: match?
    
    @IBOutlet weak var MatchedUserImage: UIImageView!
    
    @IBOutlet weak var MatchedUserName: UILabel!
}
