//
//  HelpViewController.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 17.01.2022.
//

import UIKit
import SpriteKit

class HelpViewController: UIViewController, TransitionAdapter {

    var output: HelpViewOutput?
    @IBOutlet weak var spritesView: SKView?
    
    var gameScene: HelpViewScene?
    
    @IBOutlet weak var btnMenu: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            guard let skView: SKView = self.spritesView, let scene: HelpViewScene = SKScene(fileNamed: "HelpScene") as? HelpViewScene else {
                return
            }
            self.buttonViewConfigure(self.btnMenu)
            self.gameScene = scene
            self.gameScene?.gamersDelegate = self
            scene.scaleMode = .fill
            self.output?.setInitialState()
            skView.presentScene(scene)
            skView.showsFPS = false
            skView.showsNodeCount = false
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.gameScene?.startGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNotificationListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unRegisterNotificationListener()
    }
    
    private func registerNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAnimation), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func unRegisterNotificationListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func stopAnimation() {
            self.gameScene?.enterBackground()
    }
    
    @objc func startAnimation() {
            self.gameScene?.becomeActive()
    }
    
    private func buttonViewConfigure(_ button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 3.0
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: LabelTouchedColorComponents.red/255.0, green: LabelTouchedColorComponents.green/255.0, blue: LabelTouchedColorComponents.blue/255.0, alpha: 1.0), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(isPressed), for: UIControl.Event.touchDown)
        button.addTarget(self, action: #selector(isUnPressed), for: UIControl.Event.touchCancel)
    }
    
    @objc func isPressed(button: UIButton )  -> Void {
        button.layer.borderColor = CGColor(red: ButtonTouchedStrokeColorComponents.red/255.0, green: ButtonTouchedStrokeColorComponents.green/255.0, blue: ButtonTouchedStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonTouchedFillColorComponents.red/255.0, green: ButtonTouchedFillColorComponents.green/255.0, blue: ButtonTouchedFillColorComponents.blue/255.0, alpha: 1.0)
        
    }
    
    @objc  func isUnPressed(button: UIButton) -> Void {
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonFillColorComponents.red/255.0, green: ButtonFillColorComponents.green/255.0, blue: ButtonFillColorComponents.blue/255.0, alpha: 1.0)
    }
    
    @IBAction func btnMenuTouched(_ sender: UIButton) {
        self.output?.returnToMenu()
    }
    
}

extension HelpViewController: HelpViewInput {
    
    func setLevel(level: String) {
        DispatchQueue.main.async {
            self.gameScene?.setLevel(level: level)
            
        }
    }
    
    func setPoints(points: String) {
        DispatchQueue.main.async {
            self.gameScene?.setPoints(points: points)
        }
    }
}

extension HelpViewController:  GamePlaySceneDelegate {
    
    func addPoint() {
        self.output?.addPoints()
    }
    
    func increaseLevel() {
        self.output?.addLevel()
    }
    
    func removePoint(points: Int32) {
        self.output?.removePoints(points: points)
    }
    
}
