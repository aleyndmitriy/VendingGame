//
//  HelpRightPointState.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.02.2022.
//

import SpriteKit
import GameplayKit

class HelpRightPointState: HelpPointState {
    
    override init(planogram: SKTileMapNode, associatedNode: SKLabelNode) {
        super.init(planogram: planogram, associatedNode: associatedNode)
    }
    
    override func labelText(string1: inout String, string2: inout String, string3: inout String) {
        string1 = "When product is moved correctly, you"
        string2 = "get 1 point. Point would be deducted"
        string3 = "if you got the wrong or filled cell."
    }
    
}
