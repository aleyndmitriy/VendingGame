//
//  GamersPerson.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 30.09.2021.
//

import Foundation

class GamersPerson {
    let name: String
    let birthday: Date?
    var scores: [GamersScore] = [GamersScore]()
    
    init(name: String, birthday: Date?) {
        self.name = name
        self.birthday = birthday
    }
    
    func addScoreWith(date: Date, level: Int16, points: Int32) {
        scores.append(GamersScore(date: date, level: level, points: points, owner: self))
    }

}
