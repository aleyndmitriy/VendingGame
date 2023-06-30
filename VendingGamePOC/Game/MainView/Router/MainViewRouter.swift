//
//  MainViewRouter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/29/21.
//

import Foundation
import UIKit

class MainViewRouter {
    weak var transitionAdapter: TransitionAdapter?
    
    func playGame(gamer: GamersPerson) {
        DispatchQueue.main.async {
            guard let adapter: TransitionAdapter = self.transitionAdapter, adapter.navigationController?.viewControllers.count == 1 else {
                return
            }
            if let controller: GamePlayViewController = GamePlayModuleInitializer.createModule(configurationBlock:{(moduleInput: GamePlayModuleInput)  in
                moduleInput.gamer = gamer
            }) as? GamePlayViewController {
                adapter.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func enterGamersInfo() {
        DispatchQueue.main.async {
            guard let adapter: TransitionAdapter = self.transitionAdapter, adapter.navigationController?.viewControllers.count == 1 else {
                return
            }
            if let controller: GamersInfoViewController = GamersInfoModuleInitializer.createModule(configurationBlock:{(modelInput: GamersInfoModuleInput)  in
            
            }) as? GamersInfoViewController {
                adapter.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func viewScore() {
        DispatchQueue.main.async {
            guard let adapter: TransitionAdapter = self.transitionAdapter, adapter.navigationController?.viewControllers.count == 1 else {
                return
            }
            if let controller: ScoreListViewController = ScoreListViewInitializer.createModule(configurationBlock: {(moduleInput: ScoreListViewModuleInput) in
                
            }) as? ScoreListViewController {
                adapter.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func help() {
        DispatchQueue.main.async {
            guard let adapter: TransitionAdapter = self.transitionAdapter, adapter.navigationController?.viewControllers.count == 1 else {
                return
            }
            if let controller: HelpViewController = HelpViewModuleInitializer.createModule(configurationBlock:{(moduleInput: HelpViewModuleInput)  in
                
            }) as? HelpViewController {
                adapter.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
