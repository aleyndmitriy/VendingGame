//
//  HelpArrowHintState.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 01.02.2022.
//

import SpriteKit
import GameplayKit

class HelpArrowHintState: GKState {
    
    let planogram: SKTileMapNode
    var arrow: HintArrowNode
    weak var associatedNode: SKSpriteNode?
    var transporter: SKSpriteNode?
    private var productRow: Int = 0
    private var productColumn: Int = 0
    
    init(planogram: SKTileMapNode, associatedNode: SKSpriteNode, transporter: SKSpriteNode) {
        self.planogram = planogram
        self.arrow = HintArrowNode()
        self.arrow.name = "HintArrow"
        self.transporter = transporter
        self.associatedNode = associatedNode
        super.init()
    }
    
    
    /// Highlights the sprite representing the state.
    override func didEnter(from previousState: GKState?) {
        guard let productName: String = associatedNode?.name else {
            super.didEnter(from: previousState)
            return
        }
        for row: Int in 0..<self.planogram.numberOfColumns {
            for column: Int in 0..<planogram.numberOfColumns {
                if let group: SKTileGroup =  self.planogram.tileGroup(atColumn: column, row: row), let groupName: String = group.name, productName.contains(groupName) {
                    self.productRow = row
                    self.productColumn = column
                    var point : CGPoint = self.planogram.centerOfTile(atColumn: self.productColumn, row: self.productRow)
                    point.y -= 60
                    self.planogram.addChild(self.arrow)
                    self.arrow.hintPosition = point
                    
                    if let transporterLine: SKSpriteNode = self.transporter {
                        transporterLine.removeAllActions()
                        let nodes: [SKNode] = transporterLine.children
                        for child in nodes {
                            child.removeAllActions()
                            if let childName: String = child.name, childName != productName {
                                child.removeFromParent()
                            }
                        }
                        let label: SKLabelNode = SKLabelNode(text: "Move product to appropriate cell")
                        label.fontColor = .black
                        label.fontName = "Georgia-BoldItalic"
                        label.fontSize = 32.0
                        label.verticalAlignmentMode = .center
                        let rect: CGRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 1.1*label.frame.width, height: 3*label.frame.height))
                        let shape: SKShapeNode = SKShapeNode(rect: rect, cornerRadius: 20.0)
                        shape.fillColor = .yellow
                        shape.addChild(label)
                        label.position = CGPoint(x: shape.frame.midX, y: shape.frame.midY)
                        
                        transporterLine.addChild(shape)
                        shape.position = CGPoint(x: -transporterLine.size.width/2, y: -transporterLine.size.height/2)
                        
                    }
                    self.animate()
                    return
                }
            }
        }
    }
    
    /// Unhighlights the sprite representing the state.
    override func willExit(to nextState: GKState) {
        if let helpState: HelpCellState = nextState as? HelpCellState {
            helpState.setColumnRow(column: self.productColumn, row: self.productRow)
        }
        self.associatedNode?.removeAllActions()
        self.associatedNode?.xScale = 1.0
        self.associatedNode?.yScale = 1.0
        self.associatedNode = nil
        if let transporterLine: SKSpriteNode = self.transporter {
            transporterLine.removeAllChildren()
            self.arrow.removeFromParent()
        }
    }
    
    private func animate() {
        let move: SKAction = SKAction.scale(by: 1.5, duration: 0.5)
        let moveBack: SKAction = move.reversed()
        let bounce: SKAction = SKAction.sequence([move,moveBack])
        let bounceAction: SKAction = SKAction.repeatForever(bounce)
        self.associatedNode?.run(bounceAction)
    }
    
    
}
