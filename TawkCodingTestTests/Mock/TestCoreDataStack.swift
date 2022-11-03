//
//  TestCoreDataStack.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

@testable import TawkCodingTest
import CoreData

final class TestCoreDataStack {
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "TawkCoding")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        self.mainContext = persistentContainer.viewContext
        self.backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

