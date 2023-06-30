//
//  MainViewPresenter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/29/21.
//

import Foundation

class MainViewPresenter: MainSceneDelegate {
    weak var view: MainViewController?
    let router: MainViewRouter = MainViewRouter()
    let gamersDAO: GamersDAO
    
    init(gamersDAO: GamersDAO) {
        self.gamersDAO = gamersDAO
    }
    
    func playGame() {
        self.gamersDAO.addDelegate(delegate: self)
        self.gamersDAO.getGamers()
    }
    
    func viewScore() {
        self.router.viewScore()
    }
    
    func help() {
        self.router.help()
    }
}


extension MainViewPresenter: GamersDAODelegate {
    
    func getGamers(gamers: [GamersPerson], error: Error?) {
        self.gamersDAO.removeDelegate()
        if let _ : Error = error {
            
        }
        else {
            if let gamer: GamersPerson = gamers.first {
                self.router.playGame(gamer: gamer)
            }
            else {
                self.router.enterGamersInfo()
            }
        }
    }
    
    func savingGamers(error: Error?) {
        
    }
    
    func deleteAllGamers(error: Error?) {
        
    }
}
