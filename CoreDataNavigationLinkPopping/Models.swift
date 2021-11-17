//
//  Models.swift
//  CoreDataNavigationLinkPopping
//
//  Created by Richard Witherspoon on 11/17/21.
//

import Foundation
import CoreData


@objc(Galaxy)
public class Galaxy : NSManagedObject, Identifiable {
    @NSManaged public var title        : String
    @NSManaged public var createdAt    : Date
    @NSManaged public var solarSystems : Set<SolarSystem>
    @NSManaged public var planets      : Set<Planet>
}

@objc(SolarSystem)
public class SolarSystem : NSManagedObject, Identifiable {
    @NSManaged public var title     : String
    @NSManaged public var createdAt : Date
    @NSManaged public var galaxy    : Galaxy
    @NSManaged public var planets   : Set<Planet>
}

@objc(Planet)
public class Planet : NSManagedObject, Identifiable {
    @NSManaged public var title       : String
    @NSManaged public var createdAt   : Date
    @NSManaged public var solarSystem : SolarSystem
    @NSManaged public var galaxy      : Galaxy
}

