//
//  HelpWrongPointState.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.02.2022.
//

import SpriteKit
import GameplayKit

class HelpWrongPointState: HelpPointState {
    
    override init(planogram: SKTileMapNode, associatedNode: SKLabelNode) {
        super.init(planogram: planogram, associatedNode: associatedNode)
    }
    
    override func labelText(string1: inout String, string2: inout String, string3: inout String) {
        string1 = "When product is moved incorrectly,"
        string2 = "3 points are removed. Points would"
        string3 = "increase if you got the correct cell."
    }
    
    override public func getShapeColor() -> UIColor {
        return .red
    }
}
