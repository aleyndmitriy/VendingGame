//
//  ScoreListViewInitializer.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 25.10.2021.
//

import Foundation
import UIKit

class ScoreListViewInitializer {
    static let storyboardName: String = "ScoreList"
    
    class func createModule(configurationBlock: ((ScoreListViewModuleInput) -> Void)) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: ScoreListViewInitializer.storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? ScoreListViewController else {
            return nil
        }
         
        let configurator = ScoreListViewConfigurator()
        weak var wViewController = viewController
        configurator.configureModuleForViewInput(viewInput: wViewController)

        if let moduleInput: ScoreListViewModuleInput = viewController.output as? ScoreListViewModuleInput {
            configurationBlock(moduleInput)
        } else {
            return nil
        }
       
        return viewController
    }
}
