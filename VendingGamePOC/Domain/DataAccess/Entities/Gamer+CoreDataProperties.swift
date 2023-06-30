//
//  Gamer+CoreDataProperties.swift
//  VendingGamePOC
//
//  Created by Dmitriy Aleynikov on 23.09.2021.
//
//

import Foundation
import CoreData


extension Gamer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gamer> {
        return NSFetchRequest<Gamer>(entityName: "Gamer")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var name: String?
    @NSManaged public var scores: NSSet?

}

// MARK: Generated accessors for scores
extension Gamer {

    @objc(addScoresObject:)
    @NSManaged public func addToScores(_ value: Score)

    @objc(removeScoresObject:)
    @NSManaged public func removeFromScores(_ value: Score)

    @objc(addScores:)
    @NSManaged public func addToScores(_ values: NSSet)

    @objc(removeScores:)
    @NSManaged public func removeFromScores(_ values: NSSet)

}

extension Gamer : Identifiable {

}
