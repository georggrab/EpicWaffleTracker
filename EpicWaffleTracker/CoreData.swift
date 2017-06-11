import Foundation
import CoreData

public class CoreData {

    let managedObjectModel : NSManagedObjectModel
    let persistentStoreCoordinator : NSPersistentStoreCoordinator
    
    public init(storeType : String, storeURL : URL?, schemaName : String, options : [AnyHashable : Any]?) throws {
        let bundle = Bundle(for:CoreData.self)
        var modelURL = bundle.url(forResource: schemaName, withExtension: "mom")
        if modelURL == nil {
            modelURL = bundle.url(forResource: schemaName, withExtension: "momd")
        }
        managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)!
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        try persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: storeURL, options: options)
    }

    public convenience init(sqliteDocumentName : String, schemaName : String) throws {
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        let storeURL = CoreData.applicationDocumentsDirectory().appendingPathComponent(sqliteDocumentName)
        NSLog("%@", storeURL.path)
        try self.init(storeType: NSSQLiteStoreType, storeURL: storeURL, schemaName: schemaName, options: options)
    }

    public convenience init(inMemorySchemaName : String) throws {
        try self.init(storeType: NSInMemoryStoreType, storeURL: nil, schemaName: inMemorySchemaName, options: nil)
    }

    private class func applicationDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    public func createManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
    
    static var instance : CoreData? = nil
    public static func getInstance() -> CoreData {
        if(instance == nil){
            do {
                instance = try CoreData(sqliteDocumentName: "ewt.db", schemaName: "ewt")
            }
            catch { }
        }
        return instance!
    }
}
