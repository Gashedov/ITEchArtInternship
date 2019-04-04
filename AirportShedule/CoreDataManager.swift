//
//  CoreDataManager.swift
//  AirportShedule
//
//  Created by student on 4/1/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let appDelegate: AppDelegate
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func loadDataFromDB() -> [SheduleInfoToDisplay] {
        
        print("load Data from DB")
        
        var downloadedAirports = [SheduleInfoToDisplay]()
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let request: NSFetchRequest<Country> = Country.fetchRequest()
            let airportResult = try context.fetch(request)
            for airport in airportResult {
                downloadedAirports.append(SheduleInfoToDisplay(isOpen: false, sectionName: airport.name ?? "", sectionObject: converteToAttributes(set: airport.airports ?? NSSet())))
            }

        } catch let error as NSError {
            print("Could not save \(error)")
        }
        print("Data loaded")
        return downloadedAirports
    }
    
    
    func saveAirports(airports: [SheduleInfoToDisplay]) {
        let backContext = appDelegate.persistentContainer.newBackgroundContext()
        
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            self.backgroundSaveAirports(airports: airports, context: backContext)
        }
    }
    
    
    // MARK: Private Methods
    
    private func backgroundSaveAirports(airports: [SheduleInfoToDisplay], context: NSManagedObjectContext) {
        
        context.perform {
            print("Start save data to DB")
            
            for airport in airports {
                let cdCountry = NSEntityDescription.insertNewObject(forEntityName: "Country", into: context) as! Country
                cdCountry.name = airport.sectionName
                
                airport.sectionObject
                    .map { attrs -> Airport in
                        let airport = NSEntityDescription.insertNewObject(forEntityName: "Airport", into: context) as! Airport
                        airport.city = attrs.city
                        airport.code = attrs.code
                        airport.name = attrs.airportName
                        return airport
                    }
                    .forEach(cdCountry.addToAirports)
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error)")
                }
            }
            
            print("Data saved")
        }
    }
    
    private func converteToAttributes(set: NSSet)->[Attributs]{
        var attributs = [Attributs]()
        
        for value in set{
            if let airport = value as? Airport{
            attributs.append(Attributs(city: airport.city, airportName: airport.name, code: airport.code ?? "" ))
            }
        }
        return attributs
    }
}
