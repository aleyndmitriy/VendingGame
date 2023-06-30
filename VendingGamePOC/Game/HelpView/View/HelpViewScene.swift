//
//  HelpViewScene.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 21.01.2022.
//

import UIKit
import SpriteKit
import GameplayKit

enum HelpHintName: String {
    case cellHint = "cellHint"
    case pointHint = "pointHint"
}


class HelpViewScene: SKScene {
    
    var lblScore: SKLabelNode?
    var lblLevel: SKLabelNode?
    var transporterLine: SKSpriteNode?
    var planogram: SKTileMapNode?
    var products: [SKSpriteNode] = [SKSpriteNode]()
    var tileDefinitionsDict: Dictionary<String, [SKTileDefinition]> = Dictionary<String, [SKTileDefinition]>()
    var transporterTextures: [SKTexture] = [SKTexture]()
    var transporterStep: TimeInterval = 0.04
    var transporterAnimation: SKAction?
    var produnctsOnTransporterAnimation: SKAction?
    var timer: Timer?
    var currentProduct: SKSpriteNode?
    var currentProductName: ProductName?
    var gamersDelegate: GamePlaySceneDelegate?
    private var productHeight: CGFloat = 1.2
    private var rowNumber: Int = 3
    private var columnNumber: Int = 3
    private var filledCellNumber: Int = 1
    private var updates: Int = 0
    private var saleProductPerFrame: Int = 1000
    private var distribution: GKShuffledDistribution?
    var stateMachine: GKStateMachine?
    var previousUpdateTime: TimeInterval = 0
    
    
    override func didMove(to view: SKView) {
        guard let infoSprite: SKSpriteNode = self.childNode(withName: "ScoreLevel") as? SKSpriteNode, let levelNode: SKLabelNode = infoSprite.childNode(withName: "Level") as? SKLabelNode , let scoreNode: SKLabelNode = infoSprite.childNode(withName: "Score") as? SKLabelNode,  let transporterSprite: SKSpriteNode = self.childNode(withName: "Transporter") as? SKSpriteNode, let lineSprite: SKSpriteNode = transporterSprite.childNode(withName: "TransporterLine") as? SKSpriteNode else {
            return
        }
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            self.productHeight = 1.0
        }
        
        self.lblLevel = levelNode
        self.lblScore = scoreNode
        self.transporterLine = lineSprite
        for productName in ProductName.allCases {
            let prod: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: productName.rawValue), size: CGSize(width: self.productHeight * lineSprite.size.height, height: 1.5*lineSprite.size.height + 10))
            prod.name = productName.rawValue
            products.append(prod)
        }
        
        for i in 0...8 {
            self.transporterTextures.append(SKTexture(imageNamed: "transporterline\(i)"))
        }
        self.resetToStart()
        let rand = GKMersenneTwisterRandomSource()
        self.distribution = GKShuffledDistribution(randomSource: rand, lowestValue: 0, highestValue: products.count - 1)
        super.didMove(to: view)
    }
    
    
    private func moveProduct(sprite: SKSpriteNode, duration: TimeInterval, interval: TimeInterval) {
        if self.stateMachine != nil {
            return
        }
        guard let productsPlanogram: SKTileMapNode = self.planogram, let transporter = self.transporterLine, let scoreNode: SKLabelNode = self.lblScore else {
            return
        }
        let yPos: CGFloat = transporter.position.y
        let width: CGFloat = transporter.size.width
        let pos: CGFloat = (width + CGFloat(sprite.frame.width))*(-CGFloat(interval/duration) + CGFloat(0.5))
        let delta: CGFloat = (width + CGFloat(sprite.frame.width))*CGFloat(0.30)
        sprite.position.x = CGFloat(pos)
        sprite.position.y = yPos + 50
        if sprite.position.x > delta - 2.5 && sprite.position.x < delta + 2.5  {
            if self.stateMachine == nil {
                self.stopAnimation()
                sprite.removeAllActions()
                self.stateMachine = GKStateMachine(states: [HelpArrowHintState(planogram: productsPlanogram, associatedNode: sprite, transporter: transporter), HelpRightCellState(planogram: productsPlanogram), HelpWrongCellState(planogram: productsPlanogram), HelpRightPointState(planogram: productsPlanogram, associatedNode: scoreNode), HelpWrongPointState(planogram: productsPlanogram, associatedNode: scoreNode), HelpIdleState()])
                
                self.stateMachine?.enter(HelpArrowHintState.self)
            }
            
        }
        
    }
    
    private func stopAnimation() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func startAnimation() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 50*self.transporterStep, target: self, selector: #selector(addProductOnTransporter), userInfo: nil, repeats: true)
        }
    }
    
    public func enterBackground() {
        guard let _: GKStateMachine = self.stateMachine else {
            self.stopGame()
            return
        }
    }
    
    public func becomeActive() {
        guard let _: GKStateMachine = self.stateMachine else {
            self.startGame()
            return
        }
        
    }
    
    public func stopGame() {
        guard let transporter: SKSpriteNode = self.transporterLine, let productsPlanogram: SKTileMapNode = self.planogram else {
            return
        }
        self.timer?.invalidate()
        self.timer = nil
        transporter.removeAllActions()
        for node in transporter.children {
            node.removeAllActions()
        }
        self.produnctsOnTransporterAnimation = nil
        transporter.removeAllChildren()
        for node in self.products {
            node.removeFromParent()
        }
        productsPlanogram.removeAllChildren()
        self.products.removeAll()
        self.stateMachine = nil
    }
    
    public func startGame() {
        guard  let lineSprite: SKSpriteNode = self.transporterLine else {
            return
        }
        filledCellNumber = 0
        for productName in ProductName.allCases {
            let prod: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: productName.rawValue), size: CGSize(width: self.productHeight * lineSprite.size.height, height: 1.5*lineSprite.size.height + 10))
            prod.name = productName.rawValue
            products.append(prod)
        }
        guard  let node: SKSpriteNode = products.first else {
            return
        }
        let width: CGFloat = lineSprite.size.width
        
        let duration: TimeInterval = TimeInterval((width + CGFloat(node.frame.width))/CGFloat(4/self.transporterStep))
        self.transporterAnimation = SKAction.animate(with: self.transporterTextures, timePerFrame: self.transporterStep)
        self.produnctsOnTransporterAnimation = SKAction.customAction(withDuration: duration) { (node: SKNode, interval: CGFloat) in
            if let sprite: SKSpriteNode = node as? SKSpriteNode {
                self.moveProduct(sprite: sprite, duration: duration, interval: TimeInterval(interval))
            }
        }
        guard let animation: SKAction = self.transporterAnimation  else {
            return
        }
        self.transporterLine?.run(SKAction.repeatForever(animation))
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 50*self.transporterStep, target: self, selector: #selector(addProductOnTransporter), userInfo: nil, repeats: true)
        }
    }
    
    public func resetToStart() {
        self.planogram?.removeFromParent()
        self.planogram = nil
        filledCellNumber = 0
        self.stateMachine = nil
        guard let dark: SKSpriteNode = self.childNode(withName: "Dark") as? SKSpriteNode, let tileSet: SKTileSet = SKTileSet(named: "PlanogramSet") else {
            return
        }
        self.createPlanogram(tileSet: tileSet, row: self.rowNumber, column: self.columnNumber, parentNode: dark)
        if let plan: SKTileMapNode = dark.childNode(withName: "Planogram") as? SKTileMapNode {
            plan.position = CGPoint(x: 0, y: 20)
            self.planogram = plan
            self.planogram?.enableAutomapping = false
        }
        if let mapNode: SKTileMapNode = self.planogram {
            for row: Int in 0..<mapNode.numberOfRows {
                for column: Int in 0..<mapNode.numberOfColumns {
                    if let group: SKTileGroup =  mapNode.tileGroup(atColumn: column, row: row), let rule: SKTileGroupRule = group.rules.first {
                        let definitions: [SKTileDefinition] = rule.tileDefinitions
                        if definitions.count > 0 {
                            for definition in definitions {
                                if let defqty: Int = definition.userData?["quantity"] as? Int {
                                        if defqty == 0 {
                                            definition.placementWeight = 10
                                        }
                                        else {
                                            definition.placementWeight = 0
                                        }
                                    }
                                }
                            rule.tileDefinitions = definitions
                            mapNode.setTileGroup(group, forColumn: column, row: row)
                        }
                    }
                }
            }
        }
    }
    
    private func createPlanogram(tileSet: SKTileSet, row: Int, column: Int, parentNode: SKSpriteNode) {
        let tileSize: CGSize = CGSize(width: parentNode.size.width/CGFloat(column), height: parentNode.size.height/CGFloat(row))
        var groups: [SKTileGroup] = [SKTileGroup]()
        for ind: Int in 0..<(row*column) {
            let currentGroup: SKTileGroup = tileSet.tileGroups[ind%tileSet.tileGroups.count]
            if let rule: SKTileGroupRule = currentGroup.rules.first {
                for tileDef: SKTileDefinition in rule.tileDefinitions {
                    tileDef.size = tileSize
                }
                let group: SKTileGroup = SKTileGroup(rules: [rule])
                group.name = currentGroup.name
                groups.append(group)
            }
        }
        groups.shuffle()
        let newTileSet: SKTileSet = SKTileSet(tileGroups: groups)
        newTileSet.type = .grid
        let spiral: SKTileMapNode = SKTileMapNode(tileSet: newTileSet, columns: column, rows: row, tileSize: tileSize, tileGroupLayout: groups)
        spiral.enableAutomapping = false
        spiral.name = "Planogram"
      
        parentNode.addChild(spiral)
        spiral.enableAutomapping = false
    }
    
    @objc func addProductOnTransporter() {
        if self.stateMachine != nil {
            return
        }
        guard let spriteAction: SKAction = self.produnctsOnTransporterAnimation, self.products.count > 0, let randomInt = self.distribution?.nextInt() else {
            return
        }
        guard let transporter: SKSpriteNode = self.transporterLine, let productsPlanogram: SKTileMapNode = self.planogram, let name: String = self.products[randomInt].name else {
            return
        }
        if filledCellNumber == productsPlanogram.numberOfRows * productsPlanogram.numberOfColumns {
            self.timer?.invalidate()
            self.timer = nil
            transporter.removeAllActions()
            for node in transporter.children {
                node.removeAllActions()
            }
            transporter.removeAllChildren()
            self.gamersDelegate?.increaseLevel()
            productsPlanogram.removeFromParent()
            self.planogram = nil
            return
        }
        var nodes: [SKNode] = transporter[name]
        let nodes1:[SKNode] = productsPlanogram[name]
        nodes.append(contentsOf: nodes1)
        if let node: SKNode = nodes.first, let nodeName: String = node.name {
            for productName in ProductName.allCases {
                if nodeName.contains(productName.rawValue) {
                    let prod: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: productName.rawValue), size: CGSize(width: self.productHeight * transporter.size.height, height: 1.5*transporter.size.height + 10))
                    prod.name = String(format: "%@%d", productName.rawValue, nodes.count)
                    transporter.addChild(prod)
                    prod.run(spriteAction) {
                        prod.removeFromParent()
                    }
                    break
                }
            }
        } else {
            transporter.addChild(self.products[randomInt])
            self.products[randomInt].run(spriteAction){self.products[randomInt].removeFromParent()}
        }
    }
    
    public func setLevel(level: String) {
        self.lblLevel?.text = level
    }
    
    public func setPoints(points: String) {
        self.lblScore?.text = points
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let machine: GKStateMachine = self.stateMachine, let state: GKState = machine.currentState, let touch: UITouch = touches.first, let productsPlanogram: SKTileMapNode = self.planogram else {
            return
        }
        print("begin")
        let point: CGPoint = touch.location(in: self)
        if let _: HelpArrowHintState = state as? HelpArrowHintState {
            if let node: SKSpriteNode = self.nodes(at: point).first as? SKSpriteNode, let nodeName: String = node.name {
                for productName in ProductName.allCases {
                    if nodeName.contains(productName.rawValue) {
                        node.removeAllActions()
                        node.move(toParent: productsPlanogram)
                        self.currentProduct = node
                        self.currentProductName = productName
                    }
                }
            }
            return
        }
        if let cellState: HelpCellState = state as? HelpCellState {
            if let _: SKShapeNode = self.nodes(at: point).first(where: { (item:SKNode) in
                guard let name: String = item.name else {
                    return false
                }
                return name == HelpHintName.cellHint.rawValue
            }) as? SKShapeNode {
                if let _: HelpRightCellState = cellState as? HelpRightCellState {
                    machine.enter(HelpRightPointState.self)
                }
                else if let _: HelpWrongCellState = cellState as? HelpWrongCellState {
                    machine.enter(HelpWrongPointState.self)
                }
            }
            return
        }
        
        if let _: HelpPointState = state as? HelpPointState {
            if let _: SKShapeNode = self.nodes(at: point).first(where: { (item:SKNode) in
                guard let name: String = item.name else {
                    return false
                }
                return name == HelpHintName.pointHint.rawValue
            }) as? SKShapeNode {
                    machine.enter(HelpIdleState.self)
                    resetToStart()
                    startGame()
            }
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _: HelpArrowHintState = self.stateMachine?.currentState as? HelpArrowHintState else {
            return
        }
        guard let node: SKSpriteNode = self.currentProduct, let productsPlanogram: SKTileMapNode = self.planogram  else {
            return
        }
        for touch in touches {
            let point: CGPoint = touch.location(in: productsPlanogram)
            node.position.x = point.x
            node.position.y = point.y
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _: HelpArrowHintState = self.stateMachine?.currentState as? HelpArrowHintState else {
            return
        }
        guard let touch: UITouch = touches.first, let productsPlanogram: SKTileMapNode = self.planogram, let currentNode: SKSpriteNode = self.currentProduct   else {
            return
        }
        print("end")
        let point: CGPoint = touch.location(in: productsPlanogram)
        if abs(point.y) > productsPlanogram.mapSize.height / 2 {
            currentNode.removeFromParent()
            self.currentProduct = nil
            self.currentProductName = nil
            self.stateMachine?.enter(HelpWrongCellState.self)
            return
        }
        if let node: SKSpriteNode = self.nodes(at: point).first as? SKSpriteNode, let nodeName: String = node.name, node.isEqual(to: currentNode) {
                let column: Int = productsPlanogram.tileColumnIndex(fromPosition: point)
                let row: Int = productsPlanogram.tileRowIndex(fromPosition: point)
                print("x:\(row) y:\(column)")
                if let group: SKTileGroup =  productsPlanogram.tileGroup(atColumn: column, row: row), let groupName: String = group.name, let rule: SKTileGroupRule = group.rules.first {
                    let definitions: [SKTileDefinition] = rule.tileDefinitions
                    
                    if nodeName.contains(groupName) && definitions.count > 0 {
                        if let currentDef: SKTileDefinition = productsPlanogram.tileDefinition(atColumn: column, row: row), let defName: String = currentDef.name, let quantity: Int = currentDef.userData?["quantity"] as? Int {
                            if quantity == 5 {
                                self.gamersDelegate?.removePoint(points: 2)
                                currentNode.removeFromParent()
                                self.currentProduct = nil
                                self.currentProductName = nil
                                return
                            }
                            if quantity == 4 {
                                filledCellNumber += 1
                            }
                            for definition in definitions {
                                if let defqty: Int = definition.userData?["quantity"] as? Int {
                                    if defqty == quantity + 1 {
                                        definition.placementWeight = 10
                                    }
                                    else {
                                        definition.placementWeight = 0
                                    }
                                }
                            }
                            print("defName: \(defName), quantity: \(quantity)")
                            rule.tileDefinitions = definitions
                            productsPlanogram.setTileGroup(group, forColumn: column, row: row)
                            self.gamersDelegate?.addPoint()
                            self.stateMachine?.enter(HelpRightCellState.self)
                        }
                    }
                    else {
                        self.gamersDelegate?.removePoint(points: 3)
                        self.stateMachine?.enter(HelpWrongCellState.self)
                    }
                }
        }
        currentNode.removeAllActions()
        currentNode.removeFromParent()
        self.currentProduct = nil
        self.currentProductName = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let machine: GKStateMachine = self.stateMachine else {
            return
        }
        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        previousUpdateTime = currentTime
        machine.update(deltaTime: timeSincePreviousUpdate)
    }
}
