//
//  HelpViewOutput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 17.01.2022.
//

import Foundation
protocol HelpViewOutput: AnyObject {
    func addPoints()
    func removePoints(points: Int32)
    func addLevel()
    func setInitialState()
    func returnToMenu()
}
