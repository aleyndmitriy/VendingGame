//
//  HelpViewConfigurator.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 11.11.2021.
//

import Foundation

class HelpViewConfigurator {
    
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController: HelpViewController = viewInput as? HelpViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: HelpViewController) {
        let router = HelpViewRouterImpl()
        router.transitionAdapter = viewController
        let presenter = HelpViewPresenter(router: router)
        presenter.view = viewController
        viewController.output = presenter
    }
}
