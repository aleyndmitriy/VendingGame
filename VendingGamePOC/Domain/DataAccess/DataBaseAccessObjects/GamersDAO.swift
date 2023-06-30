//
//  GamersDAO.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 30.09.2021.
//

import Foundation

protocol GamersDAO: AnyObject {
    func addDelegate(delegate: GamersDAODelegate)
    func removeDelegate()
    func insertNewGamer(name: String, birth: Date?)
    func getGamers()
    func getGamer(name: String)
    func insertNewScore(name: String, level: Int16, points: Int32, date: Date)
    func clearDatabase()
    /*func save(gamer: GamersPerson) -> Bool
    func save(scores: [GamersScore]) -> Bool
    func delete(scores: [GamersScore]) -> Bool
    func getGamers() -> [GamersPerson]
    func getScoresFor(name: String) -> [GamersScore]
    func addScore(score: GamersScore) -> Bool*/
}

protocol GamersDAODelegate: AnyObject {
    func getGamers(gamers: [GamersPerson], error: Error?)
    func savingGamers(error: Error?)
    func deleteAllGamers(error: Error?)
}
