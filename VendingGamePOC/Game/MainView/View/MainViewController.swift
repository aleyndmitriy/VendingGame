//
//  MainViewController.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/17/21.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController, TransitionAdapter {

    var presenter: MainViewPresenter = MainViewPresenter(gamersDAO: Container.sharedInstance().gamersDAO)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let skView: SKView = self.view as? SKView, let scene: MainViewScene = SKScene(fileNamed: "MainSceneView") as? MainViewScene else {
            return
        }
        scene.scaleMode = .fill
        skView.presentScene(scene)
        skView.showsFPS = false
        skView.showsNodeCount = false
        self.presenter.view = self
        self.presenter.router.transitionAdapter = self
        scene.mainViewDelegate = self.presenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
}

