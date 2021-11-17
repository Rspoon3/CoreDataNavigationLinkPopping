//
//  ContentView.swift
//  CoreDataNavigationLinkPopping
//
//  Created by Richard Witherspoon on 11/17/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .forward)])
    private var galaxies: FetchedResults<Galaxy>
    
    var body: some View {
        NavigationView{
            List(galaxies){ galaxy in
                NavigationLink {
                    GalaxyDetails(galaxy: galaxy)
                } label: {
                    Text(galaxy.title)
                }
            }
            .navigationTitle("Galaxies")
            .disabled(galaxies.isEmpty)
            .overlay(Text("No Galaxies").opacity(galaxies.isEmpty ? 1 : 0))
            .onAppear {
                PersistenceController.shared.loadDummyDataIfNeeded()
            }
        }
        .navigationViewStyle(.stack)
    }
}


struct GalaxyDetails: View{
    @FetchRequest var solarSystems : FetchedResults<SolarSystem>
    let galaxy: Galaxy
    
    init(galaxy: Galaxy){
        self.galaxy = galaxy
        
        let request = SolarSystem.fetchRequest() as! NSFetchRequest<SolarSystem>
        let predicate = NSPredicate(format: "galaxy == %@", galaxy)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        request.predicate = predicate
        _solarSystems = FetchRequest(fetchRequest: request)
    }
    
    var body: some View{
        List{
            Section("Solar Systems"){
                ForEach(solarSystems){ solarSystem in
                    NavigationLink {
                        SolarSystemDetails(solarSystem: solarSystem)
                    } label: {
                        Text(solarSystem.title)
                    }
                }
            }
        }
        .disabled(solarSystems.isEmpty)
        .overlay(Text("No Solar Systems").opacity(solarSystems.isEmpty ? 1 : 0))
        .navigationTitle(galaxy.title)
    }
}




struct SolarSystemDetails: View{
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest var planets : FetchedResults<Planet>
    let solarSystem: SolarSystem
    
    init(solarSystem: SolarSystem){
        self.solarSystem = solarSystem
        
        let request = Planet.fetchRequest() as! NSFetchRequest<Planet>
        let predicate = NSPredicate(format: "solarSystem == %@", solarSystem)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        request.predicate = predicate
        _planets = FetchRequest(fetchRequest: request)
    }
    
    var body: some View{
        List{
            Section("Planets"){
                ForEach(planets){ planet in
                    Button(planet.title){
                        planet.title = UUID().uuidString
                        try! moc.save()
                    }
                    .lineLimit(1)
                    .swipeActions {
                        Button("Delete", role: .destructive){
                            moc.delete(planet)
                            try! moc.save()
                        }
                    }
                }
            }
        }
        .disabled(planets.isEmpty)
        .overlay(Text("No planets").opacity(planets.isEmpty ? 1 : 0))
        .navigationTitle(solarSystem.title)
        .toolbar{
            ToolbarItem{
                Button("Add Planet"){
                    let planet = Planet(context: moc)
                    planet.createdAt = .now
                    planet.title = UUID().uuidString
                    planet.solarSystem = solarSystem
                    planet.galaxy = solarSystem.galaxy
                    
                    try! moc.save()
                }
            }
        }
    }
}
