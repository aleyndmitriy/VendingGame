//
//  ScoreListViewOutput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 25.10.2021.
//

import Foundation

protocol ScoreListViewOutput: AnyObject {
    func openMenuScreen()
    func getScores()
    func resetScore()
}
