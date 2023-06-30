//
//  ScoreListViewConfigurator.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 25.10.2021.
//

import Foundation

class ScoreListViewConfigurator {
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController: ScoreListViewController = viewInput as? ScoreListViewController {
            configure(viewController: viewController)
        }
    }

    
    private func configure(viewController: ScoreListViewController) {
        let router = ScoreListViewRouterImpl()
        router.transitionAdapter = viewController
        let presenter = ScoreListViewPresenter(router: router, gamersDAO: Container.sharedInstance().gamersDAO)
        presenter.view = viewController
        viewController.output = presenter
    }
}
