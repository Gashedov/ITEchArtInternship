//
//  AirportsViewModel.swift
//  AirportShedule
//
//  Created by student on 4/8/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

protocol AirportsViewModelDelegate: class {
    func receivedData()
}

class AirportsViewModel {
    weak var delegate: AirportsViewModelDelegate?
    
    private var data: [SheduleInfoToDisplay]
    var dataToDisplay : [SheduleInfoToDisplay]
    
    private let httpClient: HTTPClient
    private let coreDataManager: CoreDataManager
    
    init(appDelegate: AppDelegate) {
        coreDataManager = CoreDataManager(appDelegate: appDelegate)
        data = []
        dataToDisplay = []
        httpClient = HTTPClient()
    }
    
    func getData() {
        getDataFromDataBase(success: { data in
            self.data = self.prepareToDisplay(data)
            self.dataToDisplay = self.data
            self.delegate?.receivedData()
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
        
        self.getDataFromNetwork(success: { data in
            if self.data.isEmpty {
                self.data = self.prepareToDisplay(data)
                self.dataToDisplay = self.data
                self.delegate?.receivedData()
            }
            
            self.saveDataToDataBase(data)
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
    }
    
    func searchCountry(searchingCountry: String) {
        if searchingCountry.isEmpty {
            dataToDisplay = data
        } else {
            dataToDisplay = data.filter({$0.airportCountry.prefix(searchingCountry.count) == searchingCountry})
        }
        delegate?.receivedData()
    }
    
    //MARK:- Private methods
    private func getDataFromDataBase(success: @escaping (_ data: [AirportInfo]) -> Void,
                                     failure: @escaping (_ error: Error?) -> Void) {
        coreDataManager.loadDataFromDB { data, error in
            if data.isEmpty {
                failure(error)
                return
            }
            success(data)
        }
    }
    
    private func getDataFromNetwork(success: @escaping (_ data: [AirportInfo]) -> Void,
                                    failure: @escaping (_ error: Error?) -> Void) {
        httpClient.getAirportInfo { airports, error in
            if let error = error {
                failure(error)
                return
            }
            success(airports)
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
                let displayData = SheduleInfoToDisplay(isOpen: false, airportCountry: airports.key, airportAttributs: attributes)
                result.append(displayData)
            })
            .sorted(by: { $0.airportCountry < $1.airportCountry })
        return data
    }
}
