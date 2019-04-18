//
//  FlightInfoViewModel.swift
//  AirportShedule
//
//  Created by student on 4/16/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

protocol FlightsViewModelDelegate: class {
    func dataReceived()
}

class FlightInfoViewModel {
    
    weak var delegate: FlightsViewModelDelegate?
    
    var data: [FlightInfoToDisplay]
    private let httpClient: HTTPClient
    private let coreDataManager: CoreDataManager
    private let dateManager: DateManager
    
    init(appDelegate: AppDelegate) {
        coreDataManager = CoreDataManager(appDelegate: appDelegate)
        data = []
        httpClient = HTTPClient()
        dateManager = DateManager()
    }
    
    func getData(path: Path, airportCode: String) {
        
        let request = generateRequest(airportCode: airportCode)
        
        self.getDataFromNetwork(path: path, uponRequestParametrs: request, success: { data in
            self.data = self.prepareToDisplay(forType : path, data: data)
                self.delegate?.dataReceived()
            
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
    }
        
    private func getDataFromNetwork(path: Path, uponRequestParametrs request: [String: String], success: @escaping (_ data: [RawFlightInfo]) -> Void,
                                                                   failure: @escaping (_ error: Error?) -> Void) {
        httpClient.getFlightInfo(requestType: path, components: request, success: { (airports) in
            success(airports)
        }, failure: { error in
            if let error = error {
                failure(error)
                return
            }
        })
    }
    
    private func generateRequest(airportCode: String) -> [String:String] {
        let timeInterval = dateManager.getTime()
        let end = String(format: "%f", timeInterval.end)
        let begin = String(format: "%f", timeInterval.begin)
        let request = ["airport": airportCode, "begin": begin, "end": end]
        
        return request
    }
    
    private func prepareToDisplay(forType type: Path, data: [RawFlightInfo]) -> [FlightInfoToDisplay] {
        var result: [FlightInfoToDisplay] = []
        
        if type == Path.arrival{
            for airport in data{
                var arrivalAirportName = ""
                coreDataManager.getAirport(byIdentifier: airport.arrivalAirportCode ?? "" , result: { coreDataAirport in
                    arrivalAirportName = coreDataAirport.name ?? ""
                })
                // converte time
                result.append(FlightInfoToDisplay(AirportName: arrivalAirportName, arrivalTime: "", departureTime: ""))
            }
        }
        
        if type == Path.departure{
            for airport in data{
                var departureAirportName = ""
                coreDataManager.getAirport(byIdentifier: airport.departureAirportCode ?? "" , result: { coreDataAirport in
                    departureAirportName = coreDataAirport.name ?? ""
                })
            }
        }
        return []
    }
}
