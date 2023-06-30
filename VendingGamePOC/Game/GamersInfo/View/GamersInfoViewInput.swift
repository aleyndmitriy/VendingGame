//
//  GamersInfoViewInput.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 06.10.2021.
//

import Foundation

protocol GamersInfoViewInput: AnyObject {
    func sendMessage(message: String)
}
