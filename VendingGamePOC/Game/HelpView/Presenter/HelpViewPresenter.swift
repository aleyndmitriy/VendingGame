//
//  HelpViewPresenter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 11.11.2021.
//

import Foundation

class HelpViewPresenter: HelpViewModuleInput {
    weak var view: HelpViewInput?
    let router: HelpViewRouter
   // var timer: DispatchSourceTimer
    var score: Int32 = 5
    var level: Int16 = 1
    
    init(router: HelpViewRouter) {
        self.router = router
        //self.timer = DispatchSource.makeTimerSource(flags:[],queue: DispatchQueue.global())
        //self.timer.schedule(deadline: .now() + 5.0, repeating: 1000.0)
    }
    
}

extension HelpViewPresenter: HelpViewOutput {
    
   
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
        self.level += 1
        let strLevel: String = "\(self.level)"
        self.view?.setLevel(level: strLevel)
    }
    
    func setInitialState() {
        let strScore: String = "\(self.score)"
        self.view?.setPoints(points: strScore)
        let strLevel: String = "\(self.level)"
        self.view?.setLevel(level: strLevel)
        
        /*self.timer.setEventHandler {
            
        }
        self.timer.resume()*/
    }
    
    func returnToMenu() {
        /*self.timer.setEventHandler {}
        self.timer.cancel()
        self.timer.resume()*/
        self.router.openPreviousScreen()
    }
    
}
