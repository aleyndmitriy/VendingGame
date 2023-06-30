//
//  GamersInfoViewOutput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation

protocol GamersInfoViewOutput: AnyObject {
    func backToMainScreen()
    func tryToSaveGamer(name: String, date: Date?)
}
