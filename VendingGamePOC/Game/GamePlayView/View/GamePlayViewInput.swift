//
//  GamePlayViewInput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation

protocol GamePlayViewInput: AnyObject {
    func setLevel(level: Int16)
    func setPoints(points: String)
    func setTimer(sec: Int16)
    func setSpeed(interval: TimeInterval)
    func setSaleProductFrequency(frequency: Int)
    func setPlanogram(row: Int, column: Int)
    func messageView(message: String, level: String, dlgType: UIChangeLevelDialogType)
}
