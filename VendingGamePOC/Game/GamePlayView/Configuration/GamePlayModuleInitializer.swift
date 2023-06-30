//
//  GamePlayModuleInitializer.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation
import UIKit

class GamePlayModuleInitializer {
    static let storyboardName: String = "GamePlay"
    
    class func createModule(configurationBlock: ((GamePlayModuleInput) -> Void)) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: GamePlayModuleInitializer.storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? GamePlayViewController else {
            return nil
        }
         
        let configurator = GamePlayConfigurator()
        weak var wViewController = viewController
        configurator.configureModuleForViewInput(viewInput: wViewController)

        if let moduleInput: GamePlayModuleInput = viewController.output as? GamePlayModuleInput {
            configurationBlock(moduleInput)
        } else {
            return nil
        }
       
        return viewController
    }
}
