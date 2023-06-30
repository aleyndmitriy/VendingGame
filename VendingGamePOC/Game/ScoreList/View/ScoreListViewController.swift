//
//  ScoreListViewController.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 22.10.2021.
//

import UIKit

class ScoreListViewController: UIViewController, TransitionAdapter  {

    var output: ScoreListViewOutput?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var stackHeaderView: UIStackView!
    var alertView: UIChangeLevelDialog?
    
    private let cellIdentifier: String = "ScoreListCell"
    var gamers: [GamersPerson] = [GamersPerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView?.register(ScoreListTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.buttonViewConfigure(self.btnMenu)
        self.buttonViewConfigure(self.btnReset)
        self.output?.getScores()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.layer.cornerRadius = 20.0
        tableView.layer.borderWidth = 5.0
        tableView.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        stackHeaderView.layer.cornerRadius = 20.0
        stackHeaderView.layer.borderWidth = 4.0
        stackHeaderView.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        self.output?.getScores()
    }
    
    @IBAction func btnMenuTouched(_ sender: UIButton) {
        self.output?.openMenuScreen()
    }
    
    @IBAction func btnResetTouched(_ sender: UIButton) {
        self.messageView(message: "", text: "Do you want to clear results?", dlgType: UIChangeLevelDialogType.warning)
    }
    
    private func map(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    private func buttonViewConfigure(_ button: UIButton) {
        button.layer.cornerRadius = 20.0
        button.layer.borderWidth = 5.0
        button.layer.borderColor = CGColor(red: ButtonStrokeColorComponents.red/255.0, green: ButtonStrokeColorComponents.green/255.0, blue: ButtonStrokeColorComponents.blue/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: LabelTouchedColorComponents.red/255.0, green: LabelTouchedColorComponents.green/255.0, blue: LabelTouchedColorComponents.blue/255.0, alpha: 1.0), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(isPressed), for: UIControl.Event.touchDown)
        button.addTarget(self, action: #selector(isUnPressed), for: UIControl.Event.touchUpInside)
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
}

extension ScoreListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
           headerView.textLabel?.textColor = UIColor.white
        }
    }*/
    
    
}

extension ScoreListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gamers.count
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.gamers[section].name
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gamers[section].scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ScoreListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScoreListTableViewCell else {
            return ScoreListTableViewCell()
        }
        cell.lblUserName.text = "\(self.gamers[indexPath.section].name)"
        cell.lblDate.text = self.map(date: self.gamers[indexPath.section].scores[indexPath.row].date)
        var level: Int16 = self.gamers[indexPath.section].scores[indexPath.row].level
        if level > 1 {
            level -= 1
        }
        cell.lblLevel.text = "\(level)"
        cell.lblPoints.text = "\(self.gamers[indexPath.section].scores[indexPath.row].points)"
        return cell
    }
}

extension ScoreListViewController: ScoreListViewInput {
    
    func setGamersScores(gamers: [GamersPerson]) {
        self.gamers = gamers
        if self.gamers.count > 0 {
            DispatchQueue.main.async {
                self.btnReset.isEnabled = true
            }
        }
        else {
            DispatchQueue.main.async {
                self.btnReset.isEnabled = false
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func messageView(message: String, text: String, dlgType: UIChangeLevelDialogType) {
        DispatchQueue.main.async {
            if self.alertView == nil {
                self.alertView = UIChangeLevelDialog()
                self.alertView?.lblMessage.text = message
                self.alertView?.lbllevel.text = text
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
            }
        }
    }
}

extension ScoreListViewController: UIChangeLevelDialogDelegate {
    
    func backTouched() {
        DispatchQueue.main.async {
            if let alert = self.alertView {
                UIView.animate(withDuration: 0.3, animations: {
                }) { success in
                    alert.removeFromSuperview()
                    self.alertView = nil
                }
            }
        }
    }
    
    func nextTouched() {
        DispatchQueue.main.async {
            if let alert = self.alertView {
                UIView.animate(withDuration: 0.3, animations: {
                }) { success in
                    alert.removeFromSuperview()
                    self.alertView = nil
                }
            }
            self.output?.resetScore()
        }
    }

}
