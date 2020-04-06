//
//  DataController.swift
//  Pixel
//
//  Created by Anna Zislina on 29/02/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

//import Foundation
//
//class DataController {
//
//    //creating the persistent container
//    let persistentContainer: NSPersistentContainer
//
//    //access the context
//    var viewContext: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    init(modelName: String) {
//        persistentContainer = NSPersistentContainer(name: modelName)
//    }
//
//    //loading the persistent store
//    func load(completion: (() -> Void)? = nil) {
//        persistentContainer.loadPersistentStores { (storeDescription, error) in
//            guard error == nil else {
//                fatalError(error!.localizedDescription)
//            }
//            self.autoSaveViewContext()
//            completion?()
//        }
//    }
//}
//
//// MARK: - Autosaving
//extension DataController {
//
//    func autoSaveViewContext(interval:TimeInterval = 30) {
//        print("autosaving")
//
//        guard interval > 0 else {
//            return
//        }
//
//        if viewContext.hasChanges {
//            try? viewContext.save()
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
//            self.autoSaveViewContext(interval: interval)
//        }
//    }
//}
//
//
