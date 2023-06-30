//
//  TransitionAdapter.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 6/29/21.
//

import Foundation
import UIKit

protocol TransitionAdapter: AnyObject {
    var navigationController: UINavigationController? { get }
}
