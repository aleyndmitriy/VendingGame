//
//  GamersInfoPresenter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation

class GamersInfoPresenter {
    
    weak var view: GamersInfoViewInput?
    let router: GamersInfoRouter
    let gamersDAO: GamersDAO
    private var gamerName: String?
    private var gamerDateBirth: Date?
    
    init(router: GamersInfoRouter, gamersDAO: GamersDAO) {
        self.router = router
        self.gamersDAO = gamersDAO
    }
}

extension GamersInfoPresenter: GamersInfoViewOutput {
    
    func backToMainScreen() {
        self.gamersDAO.removeDelegate()
        self.router.openPreviousScreen()
    }
    
    func tryToSaveGamer(name: String, date: Date?) {
        self.gamerName = name
        self.gamerDateBirth = date
        self.gamersDAO.addDelegate(delegate: self)
        self.gamersDAO.getGamer(name: name)
    }
}

extension GamersInfoPresenter: GamersInfoModuleInput {
    
}

extension GamersInfoPresenter: GamersDAODelegate {
    
    func getGamers(gamers: [GamersPerson], error: Error?) {
        self.gamersDAO.removeDelegate()
        if let err : Error = error {
            self.view?.sendMessage(message: "Can't get \(err.localizedDescription) users list")
        }
        else {
            if gamers.count > 0 {
                if let name: String = self.gamerName {
                    self.view?.sendMessage(message: "User with name \(name) already exist")
                }
            }
            else {
                self.gamersDAO.addDelegate(delegate: self)
                if let name: String = self.gamerName {
                    self.gamersDAO.insertNewGamer(name: name, birth: self.gamerDateBirth)
                }
            }
        }
    }
    
    func savingGamers(error: Error?) {
        self.gamersDAO.removeDelegate()
        if let err: Error = error {
            self.view?.sendMessage(message: "Can't save \(err.localizedDescription) user")
        }
        else {
            if let name: String = self.gamerName {
                let person: GamersPerson = GamersPerson(name: name, birthday: self.gamerDateBirth)
                self.router.openGameScreen(gamer: person)
            }
        }
    }
    
    func deleteAllGamers(error: Error?) {
        
    }
}
