//
//  DataHelper.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 06/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import CoreData

// MARK: - DataHelper
class DataHelper {
    static let shared = DataHelper()
    
    // MARK: Funcations
    func getTracking() -> [Tracking] {
        let fetchRequest: NSFetchRequest<Tracking> = Tracking.fetchRequest()
        let sortDiscriptor = NSSortDescriptor(key: #keyPath(Tracking.endDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDiscriptor]
        
        guard let request = fetchRequest as? NSFetchRequest<NSManagedObject>, let trackings = CoreDataStack.shared.getObject(request: request) as? [Tracking] else {
            return []
        }
        
        return trackings
    }
    
    func saveTracking() {
        
    }
    
    func deleteTracking(index: Int) {
        let fetchRequest: NSFetchRequest<Tracking> = Tracking.fetchRequest()
        let sortDiscriptor = NSSortDescriptor(key: #keyPath(Tracking.endDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDiscriptor]
        
       
        guard let request = fetchRequest as? NSFetchRequest<NSManagedObject>, let trackings = CoreDataStack.shared.getObject(request: request) as? [Tracking] else {
            return
        }

        CoreDataStack.shared.deleteContext(object: trackings[index])
    }
}
