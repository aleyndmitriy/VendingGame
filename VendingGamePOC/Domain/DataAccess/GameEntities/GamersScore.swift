//
//  GamersScore.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 30.09.2021.
//

import Foundation

class GamersScore {
    let date: Date
    let level: Int16
    let points: Int32
    unowned let owner: GamersPerson
    
    init(date: Date, level: Int16, points: Int32, owner: GamersPerson) {
        self.date = date
        self.level = level
        self.points = points
        self.owner = owner
    }
}
