//
//  CoreDataGamerBase.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 30.09.2021.
//

import UIKit
import CoreData

let dataModelName: String = "CoreDataGamerModel"
let dataBaseName: String = "CoreDataGamerBase.sql"

class CoreDataGamerBase: NSObject {
     
    private static let shared = CoreDataGamerBase()
    var persistenStoreCoordinator: NSPersistentStoreCoordinator
    var context: NSManagedObjectContext
    
    private override init() {
        guard let modelURL = Bundle.main.url(forResource: dataModelName,
                                             withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let momd = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: dataBaseName, relativeTo: dirURL)
        print("path to base:\(String(describing: fileURL))")
        self.persistenStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: momd)
        do {
            try self.persistenStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                       configurationName: nil,
                                       at: fileURL, options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        self.context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.persistenStoreCoordinator
        super.init()
    }
    class func sharedInstance() -> CoreDataGamerBase {
        return shared
    }
}
