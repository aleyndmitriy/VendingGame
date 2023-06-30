//
//  GamersInfoViewController.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import UIKit

class GamersInfoViewController: UIViewController, TransitionAdapter {

    
    var output: GamersInfoViewOutput?
    
    @IBOutlet weak var txtGamersName: UnderlinedTextField!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var lblEnterName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtGamersName.delegate = self
        self.txtGamersName.spellCheckingType = .no
        self.buttonViewConfigure(self.btnCancel)
        self.buttonViewConfigure(self.btnOk)
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
    
    @objc func isPressed(button: UIButton )  -> Void {
        if let txt: String = self.txtGamersName.text, txt.count == 0  {
            self.lblEnterName.font = UIFont(name: "Georgia Bold", size: 35.0)
        }
        button.layer.borderColor = CGColor(red: ButtonTouchedStrokeColorComponents.red/255.0, green: ButtonTouchedStrokeColorComponents.green/255.0, blue: ButtonTouchedStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonTouchedFillColorComponents.red/255.0, green: ButtonTouchedFillColorComponents.green/255.0, blue: ButtonTouchedFillColorComponents.blue/255.0, alpha: 1.0)
        
    }
    
    @objc  func isUnPressed(button: UIButton) -> Void {
        if let txt: String = self.txtGamersName.text, txt.count == 0  {
            self.lblEnterName.font = UIFont(name: "Georgia Bold", size: 17.0)
        }
            
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: ButtonFillColorComponents.red/255.0, green: ButtonFillColorComponents.green/255.0, blue: ButtonFillColorComponents.blue/255.0, alpha: 1.0)
    }
    
    
    @IBAction func btnCancelTouched(_ sender: UIButton) {
        self.lblMessage.text = nil
        self.output?.backToMainScreen()
    }
    
    @IBAction func btnOkTouched(_ sender: UIButton) {
        guard let txt: String = self.txtGamersName.text, txt.count > 0 else {
            self.txtGamersName.textColor = .red
            self.txtGamersName.placeholder  = "Empty Name!"
            return
        }
        self.output?.tryToSaveGamer(name: txt, date: nil)
    }
    
    @IBAction func backgroundTapInside(_ sender: UIControl) {
        self.txtGamersName.resignFirstResponder()
    }
    
}

extension GamersInfoViewController: GamersInfoViewInput {
    
    func sendMessage(message: String) {
        DispatchQueue.main.async {
            self.lblMessage.text = message
        }
    }
}


extension GamersInfoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn objcRange: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let range = Range(objcRange, in: text) {
            let supposedText = text.replacingCharacters(in: range, with: string)
            if supposedText.count < 12 {
                DispatchQueue.main.async {
                    textField.text = supposedText
                }
                return true
            }
            return false
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblMessage.text = nil
        self.txtGamersName.textColor = .label
        self.txtGamersName.placeholder  = "User's Name"
    }
}
