//
//  ScoreListViewInput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 25.10.2021.
//

import Foundation

protocol ScoreListViewInput: AnyObject {
    func setGamersScores(gamers: [GamersPerson])
    func messageView(message: String, text: String, dlgType: UIChangeLevelDialogType)
}
