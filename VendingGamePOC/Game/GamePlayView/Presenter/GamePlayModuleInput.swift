//
//  GamePlayModuleInput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/30/21.
//

import Foundation

protocol GamePlayModuleInput: AnyObject {
    var gamer: GamersPerson? { get set }
}
