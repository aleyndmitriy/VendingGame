//
//  GamePlayViewOutput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation

protocol GamePlayViewOutput: AnyObject {
    func addPoints()
    func removePoints(points: Int32)
    func addLevel()
    func setInitialState()
    func returnToMenu()
    func restartLevel()
}
