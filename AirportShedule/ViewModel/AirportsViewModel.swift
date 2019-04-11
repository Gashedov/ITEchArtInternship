//
//  AirportsViewModel.swift
//  AirportShedule
//
//  Created by student on 4/8/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

protocol AirportsViewModelDelegate: class {
    func receiveddData()
}

class AirportsViewModel {
    weak var delegate: AirportsViewModelDelegate?
    
   var data: [SheduleInfoToDisplay]
    
    private let httpClient: HTTPClient
    private let coreDataManager: CoreDataManager
    
    init(appDelegate: AppDelegate) {
        coreDataManager = CoreDataManager(appDelegate: appDelegate)
        data = [SheduleInfoToDisplay]()
        httpClient = HTTPClient()
    }
    
    func getData() {
        getDataFromDataBase(success: { data in
            self.data = self.prepareToDisplay(data)
            print(self.data[0].sectionObject.count)
            self.delegate?.receiveddData()
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
        
        self.getDataFromNetwork(success: { data in
            if self.data.isEmpty {
                self.data = self.prepareToDisplay(data)
                self.delegate?.receiveddData()
            }
            
            self.saveDataToDataBase(data)
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
    }
    
    private func getDataFromDataBase(success: @escaping (_ data: [AirportInfo]) -> Void,
                                     failure: @escaping (_ error: Error?) -> Void) {
        coreDataManager.loadDataFromDB { data, error in
            data.isEmpty ? failure(error) : success(data)
        }
    }
    
    private func getDataFromNetwork(success: @escaping (_ data: [AirportInfo]) -> Void,
                                    failure: @escaping (_ error: Error?) -> Void) {
        httpClient.getAirportInfo { airports, error in
            error != nil ? failure(error) : success(airports)
        }
    }
    
    private func saveDataToDataBase(_ data: [AirportInfo]) {
        coreDataManager.saveAirports(airports: data)
    }
    
    private func prepareToDisplay(_ airports: [AirportInfo]) -> [SheduleInfoToDisplay] {
        let data = Dictionary(grouping: airports, by: { $0.country })
            .reduce(into: [SheduleInfoToDisplay](), { (result, airports) in
                let attributes = airports.value.map({ airport -> Attributs in
                    return Attributs(city: airport.city, airportName: airport.name, code: airport.code)
                })
                let displayData = SheduleInfoToDisplay(isOpen: false, sectionName: airports.key, sectionObject: attributes)
                result.append(displayData)
            })
            .sorted(by: { $0.sectionName < $1.sectionName })
        return data
    }
}

struct SheduleInfoToDisplay {
    var isOpen: Bool
    var sectionName: String
    var sectionObject: [Attributs]
}

struct Attributs {
    var city: String?
    var airportName: String?
    var code: String
}
