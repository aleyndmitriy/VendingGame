//
//  MainViewScene.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/21/21.
//

import UIKit
import SpriteKit

protocol MainSceneDelegate {
    func playGame()
    func viewScore()
    func help()
}

struct ButtonFillColorComponents {
    public static let red: CGFloat = 37.0
    public static let green: CGFloat = 48.0
    public static let blue: CGFloat = 96.0
}

struct ButtonStrokeColorComponents {
    public static let red: CGFloat = 90.0
    public static let green: CGFloat = 110.0
    public static let blue: CGFloat = 180.0
}

struct ButtonTouchedFillColorComponents {
    public static let red: CGFloat = 227.0
    public static let green: CGFloat = 183.0
    public static let blue: CGFloat = 34.0
}

struct ButtonTouchedStrokeColorComponents {
    public static let red: CGFloat = 252.0
    public static let green: CGFloat = 236.0
    public static let blue: CGFloat = 174.0
}

struct LabelTouchedColorComponents {
    public static let red: CGFloat = 30.0
    public static let green: CGFloat = 39.0
    public static let blue: CGFloat = 67.0
}

struct LabelColorComponents {
    public static let red: CGFloat = 255.0
    public static let green: CGFloat = 255.0
    public static let blue: CGFloat = 255.0
}

class MainViewScene: SKScene {
    
    var mainViewDelegate: MainSceneDelegate?
    
    private var backgroundNode: SKSpriteNode?
    private var vendingMachineImg: SKSpriteNode?
    private var labelImg: SKSpriteNode?
    private var buttons: [SKShapeNode] = [SKShapeNode]()
    private let buttonsNames: [String] = ["Play", "Best scores", "Help"]
    private var spinnyNode : SKShapeNode?
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        guard let backSprite: SKSpriteNode = self.childNode(withName: "BackgroundNode") as? SKSpriteNode, let machineImg: SKSpriteNode = backSprite.childNode(withName: "VendingMachineImage") as? SKSpriteNode, let labelNode: SKSpriteNode = backSprite.childNode(withName: "GameName") as? SKSpriteNode else {
            return
        }
        labelNode.alpha = 0.0
        labelNode.run(SKAction.fadeIn(withDuration: 2.0))
        self.backgroundNode = backSprite
        self.vendingMachineImg = machineImg
        self.labelImg = labelNode
        let h: CGFloat = backSprite.size.height/6
        let w: CGFloat = backSprite.size.width/1.8
        let height: CGFloat = labelNode.size.height/1.2
        for index: Int in 0..<self.buttonsNames.count {
            let rect = CGRect(origin: CGPoint(x: -w/2, y: -CGFloat(index)*h), size: CGSize(width: w, height: height))
            let buttonPlaySprite = SKShapeNode(rect: rect, cornerRadius: height/3.0)
            buttonPlaySprite.lineWidth = 8.0
            buttonPlaySprite.fillColor = UIColor(red: ButtonFillColorComponents.red/255.0, green: ButtonFillColorComponents.green/255.0, blue: ButtonFillColorComponents.blue/255.0, alpha: 1.0)
            buttonPlaySprite.strokeColor = UIColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
            buttonPlaySprite.name = buttonsNames[index]
            let labelSprite = SKLabelNode(text: self.buttonsNames[index])
            labelSprite.fontSize = height/2
            labelSprite.fontColor = UIColor.white
            labelSprite.fontName = "Georgia-BoldItalic"
            labelSprite.verticalAlignmentMode = .center
            labelSprite.position = CGPoint(x: buttonPlaySprite.frame.midX, y: buttonPlaySprite.frame.midY)
            buttonPlaySprite.addChild(labelSprite)
            backSprite.addChild(buttonPlaySprite)
            buttons.append(buttonPlaySprite)
        }
        let spinSize = (self.size.width + self.size.height) * 0.04
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: spinSize, height: spinSize), cornerRadius: spinSize * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.0
            spinnyNode.fillColor = UIColor.yellow
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                              SKAction.fadeOut(withDuration: 0.2),
                                              SKAction.removeFromParent()]))
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
                    return
                }
        
        let location = touch.location(in: self)
        let duration: TimeInterval = 0.4
        let touchedNodes: [SKNode] = nodes(at: location)
        for node: SKNode in touchedNodes {
            if let shape: SKShapeNode = node as? SKShapeNode {
                let scaleActionAsc: SKAction = SKAction.scaleX(to: 1.5, y: 1.3, duration: duration)
                let colorActionAsc: SKAction = SKAction.customAction(withDuration: duration) { (node: SKNode, interval: CGFloat) in
                    if let shape: SKShapeNode = node as? SKShapeNode {
                        self.makeShapeChangeColorActionAsc(shape: shape, duration: duration, interval: TimeInterval(interval))
                    }
                }
                let ascAction: SKAction = SKAction.group([scaleActionAsc, colorActionAsc])
                let scaleActionDesc: SKAction = SKAction.scale(to: 1, duration: duration)
                let colorActionDesc: SKAction = SKAction.customAction(withDuration: duration) { (node: SKNode, interval: CGFloat) in
                    if let shape: SKShapeNode = node as? SKShapeNode {
                        self.makeShapeChangeColorActionDesc(shape: shape, duration: duration, interval: TimeInterval(interval))
                    }
                }
                let descAction: SKAction = SKAction.group([scaleActionDesc, colorActionDesc])
                shape.run(SKAction.sequence([ascAction,descAction])){
                    if shape.name == self.buttonsNames[0] {
                        self.mainViewDelegate?.playGame()
                    }
                    else if shape.name == self.buttonsNames[1] {
                        self.mainViewDelegate?.viewScore()
                    }
                    else if shape.name == self.buttonsNames[2] {
                        self.mainViewDelegate?.help()
                    }
                    shape.removeAllActions()
                }
                
                return
            }
            
        }
        if let frontTouchedNode: String = atPoint(location).name,  frontTouchedNode == "BackgroundNode" {
            if let gameLabel: SKSpriteNode = self.labelImg {
                let action: SKAction = SKAction.fadeOut(withDuration: 0.5)
                let reverseAction: SKAction = SKAction.fadeIn(withDuration: 0.5)
                gameLabel.run(SKAction.sequence([action,reverseAction]))
            }
            if let machineImg = self.vendingMachineImg {
                let action: SKAction = SKAction.rotate(byAngle: 0.1, duration: 0.2)
                let reverseAction: SKAction = action.reversed()
                machineImg.run(SKAction.sequence([action,reverseAction,reverseAction,action]))
            }
        }
        
    }
    
    
    
    private func makeShapeChangeColorActionAsc(shape: SKShapeNode, duration: TimeInterval, interval: TimeInterval) {
        let fillRed: CGFloat = (ButtonTouchedFillColorComponents.red - ButtonFillColorComponents.red)*CGFloat(interval/duration) + ButtonFillColorComponents.red
        let fillGreen: CGFloat = (ButtonTouchedFillColorComponents.green - ButtonFillColorComponents.green)*CGFloat(interval/duration) + ButtonFillColorComponents.green
        let fillBlue: CGFloat = (ButtonTouchedFillColorComponents.blue - ButtonFillColorComponents.blue)*CGFloat(interval/duration) + ButtonFillColorComponents.blue
        let strokeRed: CGFloat = (ButtonTouchedStrokeColorComponents.red - ButtonStrokeColorComponents.red)*CGFloat(interval/duration) + ButtonStrokeColorComponents.red
        let strokeGreen: CGFloat = (ButtonTouchedStrokeColorComponents.green - ButtonStrokeColorComponents.green)*CGFloat(interval/duration) + ButtonStrokeColorComponents.green
        let strokeBlue: CGFloat = (ButtonTouchedStrokeColorComponents.blue - ButtonStrokeColorComponents.blue)*CGFloat(interval/duration) + ButtonStrokeColorComponents.blue
        shape.fillColor = UIColor(red: fillRed/255.0, green: fillGreen/255.0, blue: fillBlue/255.0, alpha: 1.0)
        shape.strokeColor = UIColor(red: strokeRed/255.0, green: strokeGreen/255.0, blue: strokeBlue/255.0, alpha: 1.0)
        if let node: SKNode = shape.children.first, let label: SKLabelNode = node as? SKLabelNode {
            let red: CGFloat = (LabelTouchedColorComponents.red - LabelColorComponents.red)*CGFloat(interval/duration) + LabelColorComponents.red
            let green: CGFloat = (LabelTouchedColorComponents.green - LabelColorComponents.green)*CGFloat(interval/duration) + LabelColorComponents.green
            let blue: CGFloat = (LabelTouchedColorComponents.blue - LabelColorComponents.blue)*CGFloat(interval/duration) + LabelColorComponents.blue
            label.fontColor = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        }
    }
    
    private func makeShapeChangeColorActionDesc(shape: SKShapeNode, duration: TimeInterval, interval: TimeInterval) {
        let fillRed: CGFloat = (ButtonFillColorComponents.red - ButtonTouchedFillColorComponents.red)*CGFloat(interval/duration) + ButtonTouchedFillColorComponents.red
        let fillGreen: CGFloat = (ButtonFillColorComponents.green - ButtonTouchedFillColorComponents.green)*CGFloat(interval/duration) + ButtonTouchedFillColorComponents.green
        let fillBlue: CGFloat = (ButtonFillColorComponents.blue - ButtonTouchedFillColorComponents.blue)*CGFloat(interval/duration) + ButtonTouchedFillColorComponents.blue
        let strokeRed: CGFloat = (ButtonStrokeColorComponents.red - ButtonTouchedStrokeColorComponents.red)*CGFloat(interval/duration) + ButtonTouchedStrokeColorComponents.red
        let strokeGreen: CGFloat = (ButtonStrokeColorComponents.green - ButtonTouchedStrokeColorComponents.green)*CGFloat(interval/duration) + ButtonTouchedStrokeColorComponents.green
        let strokeBlue: CGFloat = (ButtonStrokeColorComponents.blue - ButtonTouchedStrokeColorComponents.blue)*CGFloat(interval/duration) + ButtonTouchedStrokeColorComponents.blue
        shape.fillColor = UIColor(red: fillRed/255.0, green: fillGreen/255.0, blue: fillBlue/255.0, alpha: 1.0)
        shape.strokeColor = UIColor(red: strokeRed/255.0, green: strokeGreen/255.0, blue: strokeBlue/255.0, alpha: 1.0)
        if let node: SKNode = shape.children.first, let label: SKLabelNode = node as? SKLabelNode {
            let red: CGFloat = (LabelColorComponents.red - LabelTouchedColorComponents.red)*CGFloat(interval/duration) + LabelTouchedColorComponents.red
            let green: CGFloat = (LabelColorComponents.green - LabelTouchedColorComponents.green)*CGFloat(interval/duration) + LabelTouchedColorComponents.green
            let blue: CGFloat = (LabelColorComponents.blue - LabelTouchedColorComponents.blue)*CGFloat(interval/duration) + LabelTouchedColorComponents.blue
            label.fontColor = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        }
    }
    
}

