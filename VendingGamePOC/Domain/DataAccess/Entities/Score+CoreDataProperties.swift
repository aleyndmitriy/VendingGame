//
//  Score+CoreDataProperties.swift
//  VendingGamePOC
//
//  Created by Dmitriy Aleynikov on 23.09.2021.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var date: Date?
    @NSManaged public var level: Int16
    @NSManaged public var points: Int32
    @NSManaged public var owner: Gamer?

}

extension Score : Identifiable {

}
