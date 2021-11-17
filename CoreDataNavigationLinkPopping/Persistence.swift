//
//  Persistence.swift
//  CoreDataNavigationLinkPopping
//
//  Created by Richard Witherspoon on 11/17/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataNavigationLinkPopping")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func loadDummyDataIfNeeded(){
        let context = container.viewContext
        let request = Galaxy.fetchRequest() as! NSFetchRequest<Galaxy>
        let galaxyCount = try! context.count(for: request)

        guard galaxyCount == 0 else{
            return
        }
        
        
        let milkyWay = Galaxy(context: context)
        milkyWay.createdAt = .now
        milkyWay.title = "Milky Way"
        
        let andromeda = Galaxy(context: context)
        andromeda.createdAt = .now
        andromeda.title = "Andromeda"
        
        let messier81 = Galaxy(context: context)
        messier81.createdAt = .now
        messier81.title = "Messier 81"

        let homeSystem = SolarSystem(context: context)
        homeSystem.createdAt = .now
        homeSystem.title = "Home"
        homeSystem.galaxy = milkyWay
        
        let alphaCentauriSystem = SolarSystem(context: context)
        alphaCentauriSystem.createdAt = .now
        alphaCentauriSystem.title = "Alpha Centauri System"
        alphaCentauriSystem.galaxy = milkyWay


        let planetsNames = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]

        for name in planetsNames {
            let planet = Planet(context: context)
            planet.createdAt = .now
            planet.title = name
            planet.solarSystem = homeSystem
            planet.galaxy = milkyWay
        }
        
        try! context.save()
    }
}
