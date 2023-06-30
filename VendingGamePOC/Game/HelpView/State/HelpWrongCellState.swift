//
//  HelpWrongCellState.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 03.02.2022.
//

import SpriteKit
import GameplayKit

class HelpWrongCellState: HelpCellState {
    
    override init(planogram: SKTileMapNode) {
        super.init(planogram: planogram)
    }
    
    override func labelText(string1: inout String, string2: inout String) {
        string1 = "This cell should be served. "
        string2 = "The capacity has't been filled."
    }
    
    override public func getCicleColor() -> UIColor {
        return .red
    }
}
