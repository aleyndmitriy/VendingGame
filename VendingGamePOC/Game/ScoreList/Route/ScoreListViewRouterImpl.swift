//
//  ScoreListViewRouterImpl.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 25.10.2021.
//

import Foundation

class ScoreListViewRouterImpl: ScoreListViewRouter {
    weak var transitionAdapter: TransitionAdapter?
    
    func openMenuScreen() {
        DispatchQueue.main.async {
            self.transitionAdapter?.navigationController?.popViewController(animated: true)
        }
    }
}


