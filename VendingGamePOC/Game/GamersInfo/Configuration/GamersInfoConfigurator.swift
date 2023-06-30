//
//  GamersInfoConfigurator.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation

class GamersInfoConfigurator {
    
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController: GamersInfoViewController = viewInput as? GamersInfoViewController {
            configure(viewController: viewController)
        }
    }

    
    private func configure(viewController: GamersInfoViewController) {
        let router = GamersInfoRouterImpl()
        router.transitionAdapter = viewController
        let presenter = GamersInfoPresenter(router: router, gamersDAO: Container.sharedInstance().gamersDAO)
        presenter.view = viewController
        viewController.output = presenter
    }
}
