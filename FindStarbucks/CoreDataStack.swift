//
//  CoreDataStack.swift
//  FindStarbucks
//
//  Created by Alessandro Musto on 3/30/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import Foundation
import CoreData
import GooglePlaces


final class CoreDataStack {

    static let store = CoreDataStack()
    private init() {}

    var fetchedStarbucks = [Starbucks]()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "StarbucksModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    fileprivate var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func store(starbucks: GMSPlace, distance: Double) {
        let newStarbucks = Starbucks(context: context)
        newStarbucks.latitude = starbucks.coordinate.latitude
        newStarbucks.longitude = starbucks.coordinate.longitude
        newStarbucks.id = starbucks.placeID
        if let address = starbucks.formattedAddress {
            newStarbucks.address = address
        } else {
            newStarbucks.address = "no address"
        }
        newStarbucks.distance = distance

        do {
            try context.save()
        } catch {
            print("context failed to save")
        }
    }

    func fetchStarbucks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Starbucks")
        let distanceSort = NSSortDescriptor(key:"distance", ascending:true)
        fetchRequest.sortDescriptors = [distanceSort]
        do {
            self.fetchedStarbucks = try context.fetch(fetchRequest) as! [Starbucks]
        } catch {
            print("context failed to fetch")
        }
    }

    func deleteAll() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Starbucks")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try context.execute(request)
        } catch {
            print("context failed to delete")
        }
    }

  // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}





