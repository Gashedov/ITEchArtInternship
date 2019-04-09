//
//  CoreDataManager.swift
//  AirportShedule
//
//  Created by student on 4/1/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation
import CoreData

protocol DataCoreManagerDelegate : class{
    func recievedData()
}

class CoreDataManager {
    
    weak var delegate: DataCoreManagerDelegate?
    private let appDelegate: AppDelegate
    var downloadedData = [AirportInfo]()
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    func loadDataFromDB() {

        print("load Data from DB")
        let context = appDelegate.persistentContainer.newBackgroundContext() //viewContext

        appDelegate.persistentContainer.performBackgroundTask { _ in
            do {
                let request: NSFetchRequest<Airport> = Airport.fetchRequest()

                let airportResult = try context.fetch(request)
                for airport in airportResult {
                    self.downloadedData.append(AirportInfo(country: airport.country ?? "", name: airport.name ?? "", city: airport.city ?? "", code: airport.code ?? ""))
                }
                
            } catch let error as NSError {
                print("Could not save \(error)")
            }
            print("Data loaded")
            self.delegate?.recievedData()
            
        }
    }

    func saveAirports(airports: [AirportInfo]) {
        let backContext = appDelegate.persistentContainer.newBackgroundContext()

        appDelegate.persistentContainer.performBackgroundTask { (context) in
            self.backgroundSaveAirports(airports: airports, context: backContext)
        }
    }

    // MARK: Private Methods

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
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save \(error)")
                }
            }

            print("Data saved")
        }
 }
}
