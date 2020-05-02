//
//  Constants.swift
//  InTune
//
//  Created by Allyson on 4/30/20.
//

import Foundation

func getMessage(score: Int) -> String {
    if (score < 20) {
        return "Hmmmm... try again!"
    } else if (score < 40) {
        return "Ok..."
    } else if (score < 60) {
        return "Getting there"
    } else if (score < 80) {
        return "Yay!"
    } else {
        return "What a great match! "
    }
}

let formatter : DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    return df
}()


