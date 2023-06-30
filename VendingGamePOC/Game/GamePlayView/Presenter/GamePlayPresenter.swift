//
//  GamePlayPresenter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation

class GamePlayPresenter: GamePlayModuleInput, GamePlayViewOutput {
    
    weak var view: GamePlayViewInput?
    let router: GamePlayRouter
    let gamersDAO: GamersDAO
    var score: Int32 = 0
    var level: Int16 = 1
    var timerSec: Int16 = 120
    var gamer: GamersPerson?
    
    init(router: GamePlayRouter, gamersDAO: GamersDAO) {
        self.router = router
        self.gamersDAO = gamersDAO
    }
    
    func setInitialState() {
        self.gamersDAO.addDelegate(delegate: self)
        if let currentGamer: GamersPerson = self.gamer, let gamersScore: GamersScore = currentGamer.scores.last {
            self.level = gamersScore.level
            self.score = gamersScore.points
        }
        self.setInitValues()
    }
    
    func addPoints() {
        self.score += 1
        let strScore: String = "\(self.score)"
        self.view?.setPoints(points: strScore)
    }
    
    func removePoints(points: Int32) {
        self.score -= points
        if self.score < 0 {
            self.score = 0
        }
        let strScore: String = "\(self.score)"
        self.view?.setPoints(points: strScore)
    }
    
    func addLevel() {
        guard let gamer: GamersPerson = self.gamer else {
            return
        }
        var newLevel: Int16 = self.level + 1
        if self.level == 15 {
            newLevel = self.level
        }
        self.gamersDAO.insertNewScore(name: gamer.name, level: newLevel, points: self.score, date: Date())
    }
    
    func returnToMenu() {
        self.router.openPreviousScreen()
    }
    
    func restartLevel() {
        guard let gamer: GamersPerson = self.gamer else {
            return
        }
        self.gamersDAO.getGamer(name: gamer.name)
    }
    
    private func setInitValues() {
        let strScore: String = "\(self.score)"
        self.view?.setPoints(points: strScore)
        self.view?.setLevel(level: self.level)
        var interval: TimeInterval = 0.035
        if self.level == 1 {
            self.view?.setPlanogram(row: 3, column: 3)
            self.view?.setSpeed(interval: interval)
            self.view?.setTimer(sec: self.timerSec)
            return
        }
        
        if self.level > 1 && self.level < 4 {
            self.view?.setPlanogram(row: 4, column: 4)
            interval -= 0.01*TimeInterval(self.level - 1)
            self.timerSec = 150
        }
        else if self.level > 3  && self.level < 7 {
            self.view?.setPlanogram(row: 4, column: 4)
            self.view?.setSaleProductFrequency(frequency: 900)
            interval -= 0.005*TimeInterval(self.level - 2)
            self.timerSec = 210
            
        }
        else if self.level > 6  && self.level < 10 {
            self.view?.setPlanogram(row: 5, column: 5)
            self.view?.setSaleProductFrequency(frequency: 900)
            interval -= 0.005*TimeInterval(self.level - 4)
            self.timerSec = 300
        }
        else if self.level > 9  && self.level < 12 {
            self.view?.setPlanogram(row: 6, column: 6)
            self.view?.setSaleProductFrequency(frequency: 800)
            interval -= 0.005*TimeInterval(self.level - 5)
            self.timerSec = 420
        }
        else if self.level > 11 && self.level < 14 {
            self.view?.setPlanogram(row: 7, column: 7)
            self.view?.setSaleProductFrequency(frequency: 800)
            interval = 0.005
            self.timerSec = 600
        }
        else if self.level > 13 && self.level < 16 {
            self.view?.setPlanogram(row: 7, column: 7)
            self.view?.setSaleProductFrequency(frequency: 700)
            interval = 0.004
            self.timerSec = 660
        }
        else {
            self.view?.setPlanogram(row: 0, column: 0)
            interval = 0.00
        }
        self.view?.setSpeed(interval: interval)
        self.view?.setTimer(sec: self.timerSec)
    }
}

extension GamePlayPresenter: GamersDAODelegate {
    
    func getGamers(gamers: [GamersPerson], error: Error?) {
        guard let gamer: GamersPerson = self.gamer, let user: GamersPerson = gamers.first(where: {(person: GamersPerson) in
            return (person.name == gamer.name)
        }) else {
            if let err: Error = error {
                let strLevel: String = "\(self.level)"
                self.view?.messageView(message: err.localizedDescription, level: strLevel, dlgType: UIChangeLevelDialogType.error)
            }
            return
        }
        self.gamer = user
        self.setInitialState()
        self.view?.messageView(message: "Game Over", level: "Time Out", dlgType: UIChangeLevelDialogType.timeout)
    }
    
    func savingGamers(error: Error?) {
        if let err: Error = error {
            let strLevel: String = "\(self.level)"
            self.view?.messageView(message: err.localizedDescription, level: strLevel, dlgType: UIChangeLevelDialogType.error)
        } else {
            if self.level < 14 {
                let strLevel: String = "\(self.level)"
                self.level += 1
                self.setInitValues()
                self.view?.messageView(message: "Level Completed", level: strLevel, dlgType: UIChangeLevelDialogType.finish)
            }
            else {
                self.setInitValues()
                let strLevel: String = "You Win!!!"
                self.view?.messageView(message: "Congratulations!!", level: strLevel, dlgType: UIChangeLevelDialogType.win)
            }
        }
    }
    
    func deleteAllGamers(error: Error?) {
        
    }
}

