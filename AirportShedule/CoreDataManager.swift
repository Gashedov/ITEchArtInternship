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

    func loadDataFromDB(callback: @escaping ([AirportInfo], Error?) -> Void) {
        print("load Data from DB")
        
        let context = appDelegate.persistentContainer.newBackgroundContext() //viewContext

        appDelegate.persistentContainer.performBackgroundTask { _ in
            var downloadedData = [AirportInfo]()
            do {
                let request: NSFetchRequest<Airport> = Airport.fetchRequest()
                let airportResult = try context.fetch(request)
                for airport in airportResult {
                    downloadedData.append(AirportInfo(country: airport.country ?? "", name: airport.name ?? "", city: airport.city ?? "", code: airport.code ?? ""))
                }
            } catch let error as NSError {
                print("Could not save \(error)")
            }
            print("Data loaded")
            DispatchQueue.main.async {
                callback(downloadedData, nil)
            }
        }
    }

    func saveAirports(airports: [AirportInfo]) {
        let backContext = appDelegate.persistentContainer.newBackgroundContext()

        appDelegate.persistentContainer.performBackgroundTask { (context) in
            self.deleteAllData(context: backContext)
            self.backgroundSaveAirports(airports: airports, context: backContext)
        }
    }

    // MARK: Private Methods

    private func deleteAllData(context: NSManagedObjectContext) {
        do {
            let request: NSFetchRequest<Airport> = Airport.fetchRequest()
            request.returnsObjectsAsFaults = false
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            print("objects deleted ")
        } catch let error {
            print("Detele all data error :", error)
        }
    }
    
    private func backgroundSaveAirports(airports: [AirportInfo], context: NSManagedObjectContext) {

        context.perform {
            print("Start save data to DB")
            for airport in airports {
                guard let coreDataAirport = NSEntityDescription.insertNewObject(forEntityName: "Airport", into: context) as? Airport else {
                    return
                }
                coreDataAirport.country = airport.country
                coreDataAirport.city = airport.city
                coreDataAirport.code = airport.code
                coreDataAirport.name = airport.name
            }
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save \(error)")
            }
            print("Data saved")
        }
 }
}
