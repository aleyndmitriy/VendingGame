//
//  UIChangeLevelDialog.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 08.10.2021.
//

import UIKit

protocol UIChangeLevelDialogDelegate: AnyObject {
    func backTouched()
    func nextTouched()
}

enum UIChangeLevelDialogType {
    case warning
    case error
    case finish
    case timeout
    case win
}

class UIChangeLevelDialog: UIView {

    var type: UIChangeLevelDialogType = .finish {
        didSet {
            self.renameButtons()
        }
    }
    @IBOutlet var container: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lbllevel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var delegate: UIChangeLevelDialogDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ChangeLevelDialog", owner: self, options: nil)
        addSubview(container)
        self.autoresizesSubviews = true
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        container.frame = self.bounds
        self.layer.cornerRadius = 25.0
        self.layer.borderWidth = 5.0
        self.layer.masksToBounds = true
        self.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        self.buttonViewConfigure(self.btnBack)
        self.buttonViewConfigure(self.btnNext)
        
    }
    
    private func buttonViewConfigure(_ button: UIButton) {
        button.layer.cornerRadius = 30.0
        button.layer.borderWidth = 5.0
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: LabelTouchedColorComponents.red/255.0, green: LabelTouchedColorComponents.green/255.0, blue: LabelTouchedColorComponents.blue/255.0, alpha: 1.0), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(isPressed), for: UIControl.Event.touchDown)
        button.addTarget(self, action: #selector(isUnPressed), for: UIControl.Event.touchUpInside)
    }
    
    private func renameButtons() {
        switch type {
        case .error:
            self.btnNext.setTitle("Cancel", for: UIControl.State.normal)
            self.btnBack.setTitle("Try Again", for: UIControl.State.normal)
            break
        case .warning:
            self.btnNext.setTitle("Ok", for: UIControl.State.normal)
            self.btnBack.setTitle("Cancel", for: UIControl.State.normal)
            break
        case .finish:
            self.btnNext.setTitle("Next", for: UIControl.State.normal)
            self.btnBack.setTitle("Menu", for: UIControl.State.normal)
            break
        case .timeout:
            self.btnNext.setTitle("Try again", for: UIControl.State.normal)
            self.btnBack.setTitle("Menu", for: UIControl.State.normal)
            break
        case .win:
            self.btnNext.isHidden = true
            self.btnBack.setTitle("Menu", for: UIControl.State.normal)
            break
        }
    }
    
    @objc func isPressed(button: UIButton )  -> Void {
        button.layer.borderColor = CGColor(red: ButtonTouchedStrokeColorComponents.red/255.0, green: ButtonTouchedStrokeColorComponents.green/255.0, blue: ButtonTouchedStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonTouchedFillColorComponents.red/255.0, green: ButtonTouchedFillColorComponents.green/255.0, blue: ButtonTouchedFillColorComponents.blue/255.0, alpha: 1.0)
        button.titleLabel?.textColor = UIColor(red: LabelTouchedColorComponents.red/255.0, green: LabelTouchedColorComponents.green/255.0, blue: LabelTouchedColorComponents.blue/255.0, alpha: 1.0)
        
    }
    
    @objc  func isUnPressed(button: UIButton) -> Void {
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonFillColorComponents.red/255.0, green: ButtonFillColorComponents.green/255.0, blue: ButtonFillColorComponents.blue/255.0, alpha: 1.0)
        button.titleLabel?.textColor = UIColor(red: LabelColorComponents.red/255.0, green: LabelColorComponents.green/255.0, blue: LabelColorComponents.blue/255.0, alpha: 1.0)
    }
    
    
    @IBAction func btnBackTouched(_ sender: UIButton) {
        self.delegate?.backTouched()
    }
    
    @IBAction func btnNextTouched(_ sender: UIButton) {
        self.delegate?.nextTouched()
    }
    
}
