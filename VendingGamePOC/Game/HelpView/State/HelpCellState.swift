//
//  HelpCellState.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 04.02.2022.
//

import SpriteKit
import GameplayKit

class HelpCellState: GKState {
    
    private let planogram: SKTileMapNode
    private var productRow: Int = 0
    private var productColumn: Int = 0
    private var shape: SKShapeNode?
    private var cicle: SKShapeNode?
    
    init(planogram: SKTileMapNode) {
        self.planogram = planogram
        super.init()
    }
    
    public func setColumnRow(column: Int, row: Int) {
        self.productColumn = column
        self.productRow = row
    }
    
    override func didEnter(from previousState: GKState?) {
        self.planogram.removeAllChildren()
        let planogramPoint : CGPoint = self.planogram.centerOfTile(atColumn: self.productColumn, row: self.productRow)
        self.createLabel(point: planogramPoint)
    }
    
    override func willExit(to nextState: GKState) {
        self.planogram.removeAllChildren()
        super.willExit(to: nextState)
    }
    
    
    public func labelText(string1: inout String, string2: inout String) {
        
    }
    
    public func getCicleColor() -> UIColor {
        return .white
    }
    
    private func createLabel(point: CGPoint) {
        guard let font: UIFont = UIFont(name: "Georgia-BoldItalic", size: 34.0) else {
            return
        }
        let attributesForTitle = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        var string1: String = String()
        var string2: String = String()
        self.labelText(string1: &string1, string2: &string2)
        let attributedStringForTitle = NSMutableAttributedString(string: string1, attributes: attributesForTitle)
        let hyphenation: NSAttributedString = NSAttributedString(string: "\n")
        let attrString1 = NSAttributedString(string: string2, attributes: attributesForTitle)
        let attrString2 = NSAttributedString(string: "Tap to continue...", attributes: attributesForTitle)
        attributedStringForTitle.append(hyphenation)
        attributedStringForTitle.append(attrString1)
        attributedStringForTitle.append(hyphenation)
        attributedStringForTitle.append(attrString2)
        let label: SKLabelNode = SKLabelNode(attributedText: attributedStringForTitle)
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        let rect: CGRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 1.1*label.frame.width, height: 2*label.frame.height))
        self.shape = SKShapeNode(rect: rect, cornerRadius: 20.0)
        guard let shape: SKShapeNode = self.shape else {
            return
        }
        shape.fillColor = self.getCicleColor()
        shape.addChild(label)
        label.position = CGPoint(x: shape.frame.midX, y: shape.frame.midY)
        shape.name = HelpHintName.cellHint.rawValue
        self.planogram.addChild(shape)
        var newPoint: CGPoint = point
        newPoint.x -= shape.frame.size.width/2
        newPoint.y += self.planogram.tileSize.height/10
        if self.productColumn == 0 {
            newPoint.x += self.planogram.tileSize.width/1.8
        }
        else if self.productColumn == self.planogram.numberOfColumns - 1 {
            newPoint.x -= (self.planogram.tileSize.width/1.5)
        }
        shape.position = newPoint
        self.cicle = SKShapeNode(circleOfRadius: self.planogram.tileSize.width/3)
        guard let cicle: SKShapeNode = self.cicle else {
            return
        }
        cicle.fillColor = self.getCicleColor()
        cicle.alpha = 0.50
        self.planogram.addChild(cicle)
        newPoint.x = point.x - self.planogram.tileSize.width/3
        newPoint.y = point.y - self.planogram.tileSize.height/3
        cicle.position = newPoint
        self.animate()
    }
    
    private func animate() {
        let move: SKAction = SKAction.scale(by: 1.1, duration: 0.8)
        let moveBack: SKAction = move.reversed()
        let bounce: SKAction = SKAction.sequence([move,moveBack])
        let bounceAction: SKAction = SKAction.repeatForever(bounce)
        self.shape?.run(bounceAction)
    }
}
