//
//  HelpRightCellState.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 03.02.2022.
//

import SpriteKit
import GameplayKit

class HelpRightCellState: HelpCellState {
   
    override init(planogram: SKTileMapNode) {
        super.init(planogram: planogram)
    }
    
    override func labelText(string1: inout String, string2: inout String) {
        string1 = "Here is cell capacity:"
        string2 = "you have filled up 1 to 5."
    }
    
    override public func getCicleColor() -> UIColor {
        return .yellow
    }
}
