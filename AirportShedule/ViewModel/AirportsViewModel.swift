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
        coreDataManager.loadDataFromDB { data, _ in
            self.data = self.prepareToDisplay(data)
        }
        
        if self.data.isEmpty {
            httpClient.getAirportInfo {airports, _ in
                self.data = self.prepareToDisplay(airports)
                self.coreDataManager.saveAirports(airports: airports)
                DispatchQueue.main.async {
                    self.delegate?.receiveddData()
                }
                
            }
            
        }
        
        
    }
    
    private func prepareToDisplay(_ airports: [AirportInfo]) -> [SheduleInfoToDisplay] {
        let data = Dictionary(grouping: airports, by: { $0.country })
            .reduce(into: [SheduleInfoToDisplay](), { (result, airports) in
                let attributes = airports.value.map({ airport -> Attributs in
                    return Attributs(city: airport.city, airportName: airport.name, code: airport.code)
                })
                let displayData = SheduleInfoToDisplay(sectionName: airports.key, sectionObject: attributes)
                result.append(displayData)
            })
            .sorted(by: { $0.sectionName < $1.sectionName })
        return data
    }
}

struct SheduleInfoToDisplay {
    var sectionName: String
    var sectionObject: [Attributs]
}

struct Attributs {
    var city: String?
    var airportName: String?
    var code: String
}
