//
//  Container.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation

class Container {
    private static var shared: Container!
    public var gamersDAO: GamersDAO
    
    private init(gamersDAO: GamersDAO) {
        self.gamersDAO = gamersDAO
    }
    
    class func resolveForCoreData() {
        shared = Container.init(gamersDAO: GamersCoreDataDAO())
    }
    
    class func sharedInstance() -> Container {
        return shared
    }
}
