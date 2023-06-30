//
//  GamePlayRouterImpl.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation

class GamePlayRouterImpl: GamePlayRouter {
    
    weak var transitionAdapter: TransitionAdapter?
    func openPreviousScreen() {
        DispatchQueue.main.async {
            self.transitionAdapter?.navigationController?.popViewController(animated: true)
        }
    }
}
