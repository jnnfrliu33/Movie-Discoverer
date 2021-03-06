//
//  CoreDataStack.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 10/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import CoreData

// MARK: - CoreDataStack

struct CoreDataStack {
    
    // MARK: Properties
    
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let databaseURL: URL
    let context: NSManagedObjectContext
    
    // MARK: Initializers
    
    init?(modelName: String) {
        
        // Assumes the model is in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil
        }
        self.modelURL = modelURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        // Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // create a context and add connect it to the coordinator
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        // Add a SQLite store located in the documents folder
        let fileManager = FileManager.default
        
        guard let docUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.databaseURL = docUrl.appendingPathComponent("model.sqlite")
        
        // Options for migration
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: databaseURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("unable to add store at \(databaseURL)")
        }
    }
    
    // MARK: Utils
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: databaseURL, options: nil)
    }
    
    // Singleton
    static func sharedInstance() -> CoreDataStack {
        struct Singleton {
            static var sharedInstance = CoreDataStack(modelName: "Model")
        }
        return Singleton.sharedInstance!
    }
}

// MARK: - CoreDataStack (Removing Data)

internal extension CoreDataStack  {
    
    func dropAllData() throws {
        // Delete all the objects in the database
        try coordinator.destroyPersistentStore(at: databaseURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: databaseURL, options: nil)
    }
}

// MARK: - CoreDataStack (Save Data)

extension CoreDataStack {
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
