//
//  GamePlayViewController.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import UIKit
import SpriteKit
import WebKit

class GamePlayViewController: UIViewController, TransitionAdapter {

    @IBOutlet weak var spritesView: SKView?
    
    var output: GamePlayViewOutput?
    var gameScene: GamePlayScene?
    var alertView: UIChangeLevelDialog?
    @IBOutlet weak var btnMenu: UIButton!
    
    private var timerSec: Int16 = 0
    private var timer: DispatchSourceTimer?
    private var isGameRunning = true
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let skView: SKView = self.spritesView, let scene: GamePlayScene = SKScene(fileNamed: "GamePlayScene") as? GamePlayScene else {
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
        self.setTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNotificationListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unRegisterNotificationListener()
        self.stopTimer()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func btnMenuTouched(_ sender: UIButton) {
        self.output?.returnToMenu()
    }
    
    private func buttonViewConfigure(_ button: UIButton) {
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 3.0
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: LabelTouchedColorComponents.red/255.0, green: LabelTouchedColorComponents.green/255.0, blue: LabelTouchedColorComponents.blue/255.0, alpha: 1.0), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(isPressed), for: UIControl.Event.touchDown)
        button.addTarget(self, action: #selector(isUnPressed), for: UIControl.Event.touchUpInside)
    }
    
    @objc func isPressed(button: UIButton )  -> Void {
        button.layer.borderColor = CGColor(red: ButtonTouchedStrokeColorComponents.red/255.0, green: ButtonTouchedStrokeColorComponents.green/255.0, blue: ButtonTouchedStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonTouchedFillColorComponents.red/255.0, green: ButtonTouchedFillColorComponents.green/255.0, blue: ButtonTouchedFillColorComponents.blue/255.0, alpha: 1.0)
        
    }
    
    @objc  func isUnPressed(button: UIButton) -> Void {
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonFillColorComponents.red/255.0, green: ButtonFillColorComponents.green/255.0, blue: ButtonFillColorComponents.blue/255.0, alpha: 1.0)
    }
    
    private func registerNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopAnimation), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func stopAnimation() {
        if self.isGameRunning {
            self.gameScene?.stopAnimation()
        }
    }
    
    @objc func startAnimation() {
        if self.isGameRunning {
            self.gameScene?.startAnimation()
        }
    }
    
    @objc func fireTimer() {
        self.timerSec -= 1
        let min: Int16 = self.timerSec/60
        let sec: Int16 = self.timerSec % 60
        let timerStr: String = "\(min):\(sec)"
        DispatchQueue.main.async {
            self.gameScene?.setTimer(time: timerStr)
        }
        if self.timerSec == 0 {
            self.isGameRunning = false
            self.gameScene?.stopGame()
            self.stopTimer()
            self.output?.restartLevel()
        }
    }
    
    private func setTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
            self.timer?.schedule(deadline: .now(), repeating: .seconds(1))
            self.timer?.setEventHandler(handler: {
                [weak self] in
                self?.fireTimer()
            })
            self.timer?.resume()
        }
    }
    
    private func stopTimer() {
        if self.timer != nil {
            self.timer?.setEventHandler {}
            self.timer?.suspend()
            self.timer?.cancel()
            self.timer?.resume()
        }
    }
    
    private func unRegisterNotificationListener() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension GamePlayViewController: GamePlayViewInput {
    
    func setLevel(level: Int16) {
        DispatchQueue.main.async {
            self.gameScene?.setLevel(level: level)
        }
    }
    
    func setPoints(points: String) {
        DispatchQueue.main.async {
            self.gameScene?.setPoints(points: points)
        }
    }
    
    func setPlanogram(row: Int, column: Int) {
        self.gameScene?.setPlanogramsGeometry(row: row, column: column)
    }
    
    func setSpeed(interval: TimeInterval) {
        DispatchQueue.main.async {
            self.gameScene?.setTransporterSpeed(speed: interval)
        }
    }
    
    func setSaleProductFrequency(frequency: Int) {
        DispatchQueue.main.async {
            self.gameScene?.setSaleFrequency(frequency: frequency)
        }
    }
    
    func setTimer(sec: Int16) {
        self.timerSec = sec
        let min: Int16 = self.timerSec/60
        let sec: Int16 = self.timerSec % 60
        let timerStr: String = "\(min):\(sec)"
        DispatchQueue.main.async {
            self.gameScene?.setTimer(time: timerStr)
        }
    }
    
    func messageView(message: String, level: String, dlgType: UIChangeLevelDialogType) {
        guard let skView: SKView = self.spritesView else {
            return
        }
        DispatchQueue.main.async {
            if self.alertView == nil {
                
                self.alertView = UIChangeLevelDialog()
                self.alertView?.lblMessage.text = message
                self.alertView?.lbllevel.text = level
                self.alertView?.type = dlgType
                self.alertView?.delegate = self
                self.view.addSubview(self.alertView!)
                self.view.bringSubviewToFront(self.alertView!)
                self.alertView?.translatesAutoresizingMaskIntoConstraints = false
                let heighConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.alertView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 355)
                let widthConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.alertView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 300)
                let centerXConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.alertView!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0)
                let centerYConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.alertView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0)
               
                NSLayoutConstraint.activate([centerXConstraint, centerYConstraint, heighConstraint, widthConstraint])
                self.view.layoutIfNeeded()
                skView.isUserInteractionEnabled = false
            }
        }
    }
}

extension GamePlayViewController: GamePlaySceneDelegate {
    
    func addPoint() {
        self.output?.addPoints()
    }
    
    func increaseLevel() {
        self.stopTimer()
        self.output?.addLevel()
    }
    
    func removePoint(points: Int32) {
        self.output?.removePoints(points: points)
    }
}

extension GamePlayViewController: UIChangeLevelDialogDelegate {
    
    func backTouched() {
        DispatchQueue.main.async {
            guard let skView: SKView = self.spritesView else {
                return
            }
            if let alert = self.alertView {
                UIView.animate(withDuration: 0.3, animations: {
                }) { success in
                    alert.removeFromSuperview()
                    self.alertView = nil
                    skView.isUserInteractionEnabled = true
                }
            }
            self.output?.returnToMenu()
        }
        
    }
    
    func nextTouched() {
        DispatchQueue.main.async {
            guard let skView: SKView = self.spritesView else {
                return
            }
            if let alert = self.alertView {
                UIView.animate(withDuration: 0.3, animations: {
                }) { success in
                    alert.removeFromSuperview()
                    self.alertView = nil
                    skView.isUserInteractionEnabled = true
                }
            }
            self.timer = nil
            self.gameScene?.resetToStart()
            self.gameScene?.startGame()
            self.setTimer()
            self.isGameRunning = true
        }
    }

}
