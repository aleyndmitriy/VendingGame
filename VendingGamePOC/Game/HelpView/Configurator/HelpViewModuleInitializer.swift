//
//  HelpViewModuleInitializer.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 11.11.2021.
//

import Foundation
import UIKit

class HelpViewModuleInitializer {
    static let storyboardName: String = "HelpView"
    
    class func createModule(configurationBlock: ((HelpViewModuleInput) -> Void)) -> UIViewController? {
        let storyboard = UIStoryboard(name: HelpViewModuleInitializer.storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? HelpViewController else {
            return nil
        }
        let configurator = HelpViewConfigurator()
        weak var wViewController = viewController
        configurator.configureModuleForViewInput(viewInput: wViewController)
        if let moduleInput: HelpViewModuleInput = viewController.output as? HelpViewModuleInput {
            configurationBlock(moduleInput)
        } else {
            return nil
        }
        return viewController
    }
}
