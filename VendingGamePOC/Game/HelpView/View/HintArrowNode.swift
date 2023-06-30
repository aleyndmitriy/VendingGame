//
//  HintArrowNode.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 13.01.2022.
//

import UIKit
import SpriteKit

class HintArrowNode: SKSpriteNode {
    
    var hintPosition: CGPoint {
        get {
            return super.position
        }
        set(newValue) {
            super.position = newValue
            self.animate()
        }
    }
    
    init(){
        let texture: SKTexture = SKTexture(imageNamed: "bold_green_arrow")
        super.init(texture: texture, color: UIColor.clear,size: texture.size())
        self.xScale = CGFloat(2.0)
        self.yScale = CGFloat(2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xScale = CGFloat(2.0)
        self.yScale = CGFloat(2.0)
    }
    
    private func animate() {
        let move: SKAction = SKAction.moveTo(y: self.position.y + CGFloat(30.0), duration: 0.5)
        let moveBack: SKAction = SKAction.moveTo(y:self.position.y - CGFloat(30.0), duration: 0.5)
        let bounce: SKAction = SKAction.sequence([move,moveBack])
        
        let bounceAction: SKAction = SKAction.repeatForever(bounce)
        self.run(bounceAction) {
            self.removeFromParent()
        }
    }
    
    deinit {
        self.removeAllActions()
    }
}
