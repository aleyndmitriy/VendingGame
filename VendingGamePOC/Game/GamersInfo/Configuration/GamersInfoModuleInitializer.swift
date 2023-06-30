//
//  GamersInfoModuleInitializer.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation
import UIKit

class GamersInfoModuleInitializer {
    static let storyboardName: String = "GamersInfo"
    
    class func createModule(configurationBlock: ((GamersInfoModuleInput) -> Void)) -> UIViewController? {
        let storyboard = UIStoryboard(name: GamersInfoModuleInitializer.storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? GamersInfoViewController else {
            return nil
        }
        let configurator = GamersInfoConfigurator()
        weak var wViewController = viewController
        configurator.configureModuleForViewInput(viewInput: wViewController)
        if let moduleInput: GamersInfoModuleInput = viewController.output as? GamersInfoModuleInput {
            configurationBlock(moduleInput)
        } else {
            return nil
        }
        return viewController
    }
}
