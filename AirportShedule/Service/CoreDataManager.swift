//
//  CoreDataManager.swift
//  AirportShedule
//
//  Created by student on 4/1/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation
import CoreData

enum DataBaseError: Error {
    case loadDataError
    case saveDataError
    case deleteDataError
    case filteringError
    case nilField

    var description: String {
        switch self {
        case .loadDataError:
            return "Could not load airports."
        case .saveDataError:
            return "Could not save data."
        case .deleteDataError:
            return "Could not delete data."
        case .filteringError:
            return "Could not find the requested field"
        case .nilField:
            return "Requested field is nil"
        }
    }
}

class CoreDataManager {

    private let appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    func loadDataFromDB(success: @escaping ([AirportInfo]) -> Void,
                        failure: @escaping (DataBaseError) -> Void) {
        NSLog("Load Data from DB")

        let context = appDelegate.persistentContainer.newBackgroundContext() //viewContext

        appDelegate.persistentContainer.performBackgroundTask { _ in
            var downloadedData: [AirportInfo] = []
            do {
                let request: NSFetchRequest<Airport> = Airport.fetchRequest()
                let airportResult = try context.fetch(request)
                for airport in airportResult {
                    downloadedData.append(AirportInfo(country: airport.country ?? "",
                                                      name: airport.name ?? "",
                                                      city: airport.city ?? "",
                                                      code: airport.code ?? ""))
                }
            } catch _ as NSError {
                failure(.loadDataError)
            }
            NSLog("Data loaded")
            DispatchQueue.main.async {
                success(downloadedData)
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

    func getAirport(byIdentifier identifier: String, result: @escaping (AirportInfo) -> Void) {
        let context = appDelegate.persistentContainer.newBackgroundContext()
        appDelegate.persistentContainer.performBackgroundTask { _ in
            do {// можно ли как то ограничить количество запросов?
                let fetchRequest: NSFetchRequest<Airport> = Airport.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "code == %@", identifier)
                fetchRequest.returnsObjectsAsFaults = false
                let fetchedResults = try context.fetch(fetchRequest)
                if let airport = fetchedResults.first {
                    DispatchQueue.main.async {
                        result(AirportInfo(country: airport.country ?? "",
                                           name: airport.name ?? "",
                                           city: airport.city ?? "",
                                           code: airport.code ?? ""))
                    }
                }
            } catch {
                NSLog(DataBaseError.saveDataError.description)
            }
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
            NSLog("Objects deleted")
        } catch _ {
            NSLog(DataBaseError.deleteDataError.description)
        }
    }

    private func backgroundSaveAirports(airports: [AirportInfo], context: NSManagedObjectContext) {

        context.perform {
            NSLog("Start save data to DB")
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
            } catch _ as NSError {
                NSLog(DataBaseError.saveDataError.description)
            }
            NSLog("Data saved")
        }
 }
}
