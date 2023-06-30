//
//  GamersInfoRouterImpl.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation
import UIKit

class GamersInfoRouterImpl: GamersInfoRouter {
    weak var transitionAdapter: TransitionAdapter?
    
    func openGameScreen(gamer: GamersPerson) {
        DispatchQueue.main.async {
            guard let adapter: TransitionAdapter = self.transitionAdapter, let navController: UINavigationController = adapter.navigationController else {
                return
            }
            if let controller: GamePlayViewController = GamePlayModuleInitializer.createModule(configurationBlock:{(moduleInput: GamePlayModuleInput)  in
                moduleInput.gamer = gamer
            
            }) as? GamePlayViewController {
                var controllers: [UIViewController] = navController.viewControllers
                controllers.removeLast()
                controllers.append(controller)
                navController.setViewControllers(controllers, animated: true)
            }
        }
    }
    
    func openPreviousScreen() {
        DispatchQueue.main.async {
            self.transitionAdapter?.navigationController?.popViewController(animated: true)
        }
    }
}
