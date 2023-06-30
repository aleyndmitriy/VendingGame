//
//  ScoreListViewPresenter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 25.10.2021.
//

import Foundation
class ScoreListViewPresenter: ScoreListViewModuleInput, ScoreListViewOutput {
    
    weak var view: ScoreListViewInput?
    let router: ScoreListViewRouter
    let gamersDAO: GamersDAO
    
    init(router: ScoreListViewRouter, gamersDAO: GamersDAO) {
        self.router = router
        self.gamersDAO = gamersDAO
       
    }
    
    func openMenuScreen() {
        self.router.openMenuScreen()
    }
    
    func getScores() {
        self.gamersDAO.addDelegate(delegate: self)
        self.gamersDAO.getGamers()
    }
    
    func resetScore() {
        self.gamersDAO.clearDatabase()
    }
}

extension ScoreListViewPresenter: GamersDAODelegate {

    func getGamers(gamers: [GamersPerson], error: Error?) {
        if let _ : Error = error {
            self.view?.setGamersScores(gamers: [GamersPerson]())
        } else {
            let res: [GamersPerson] = gamers.sorted { (gamer1: GamersPerson, gamer2: GamersPerson) in
                gamer1.name < gamer2.name
            }
            self.view?.setGamersScores(gamers: res)
        }
    }
    
    func savingGamers(error: Error?) {
        
    }
    
    func deleteAllGamers(error: Error?) {
        if error == nil {
            self.view?.setGamersScores(gamers: [])
        }
       
    }
    
}
