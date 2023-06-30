//
//  GamersInfoRouter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation

protocol GamersInfoRouter: AnyObject {
    func openGameScreen(gamer: GamersPerson)
    func openPreviousScreen()
}
