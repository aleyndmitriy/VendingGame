//
//  HelpViewRouterImpl.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 11.11.2021.
//

import Foundation
import UIKit

class HelpViewRouterImpl: HelpViewRouter {
    
    weak var transitionAdapter: TransitionAdapter?
    
    func openPreviousScreen() {
        guard let adapter: TransitionAdapter = self.transitionAdapter, let navController: UINavigationController = adapter.navigationController else {
            return
        }
        DispatchQueue.main.async {
            navController.popViewController(animated: true)
        }
    }
}
