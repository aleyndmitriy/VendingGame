//
//  HelpViewInput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 17.01.2022.
//

import Foundation

protocol HelpViewInput: AnyObject {
    func setLevel(level: String)
    func setPoints(points: String)
}
