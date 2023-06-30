//
//  GamePlayConfigurator.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation

class GamePlayConfigurator {
    
    
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController: GamePlayViewController = viewInput as? GamePlayViewController {
            configure(viewController: viewController)
        }
    }

    
    private func configure(viewController: GamePlayViewController) {
        let router = GamePlayRouterImpl()
        router.transitionAdapter = viewController
        let presenter = GamePlayPresenter(router: router, gamersDAO: Container.sharedInstance().gamersDAO)
        presenter.view = viewController
        viewController.output = presenter
    }
}
