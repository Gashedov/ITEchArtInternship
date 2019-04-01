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
            let airportResult = try context.fetch(Airport.fetchRequest())
            
            guard let airports = airportResult as? [Airport] else {
                print("Can not load airports info from Core Data")
                return downloadedAirports
            }
            
            for airport in airports {
                downloadedAirports.append(SheduleInfoToDisplay(isOpen: false, sectionName: airport.country ?? "UNknown country", sectionObject: []))
            }

        } catch let error as NSError {
            print("Could not save \(error)")
        }
        
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
                let cdAirport = Airport(context:  context)
                cdAirport.setValue(airport.sectionName, forKey: "country")
                
                for atribut in airport.sectionObject {
                    
                    let cdAirportAttributes = AirportAttributes(context: context)
                    cdAirportAttributes.setValue(atribut.city, forKey: "city")
                    cdAirportAttributes.setValue(atribut.code, forKey: "code")
                    cdAirportAttributes.setValue(atribut.airportName, forKey: "airportName")
                    
                }
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error)")
                }
            }
            
            print("Finish save data")
        }
    }
}
