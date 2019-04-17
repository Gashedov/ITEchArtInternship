//
//  FlightInfoViewModel.swift
//  AirportShedule
//
//  Created by student on 4/16/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

protocol FlightsViewModelDelegate: class{
    func dataReceived()
}

class FlightInfoViewModel {
    
    weak var delegate: FlightsViewModelDelegate?
    
    var data: [FlightInfoToDisplay]
    private let httpClient: HTTPClient
    private let coreDataManager: CoreDataManager
    
    init(appDelegate: AppDelegate) {
        coreDataManager = CoreDataManager(appDelegate: appDelegate)
        data = []
        httpClient = HTTPClient()
    }
    
    func getData(airportCode: String){
        
        let request = generateRequest(airportCode: airportCode)
        
        self.getDataFromNetwork(upon: request, success: { data in
                self.data = self.prepareToDisplay(data: data)
                self.delegate?.dataReceived()
            
        }, failure: { error in
            print("Error: \(String(describing: error))")
        })
    }
        
    private func getDataFromNetwork(upon request: [String:String], success: @escaping (_ data: [RawFlightInfo]) -> Void,
                                                                   failure: @escaping (_ error: Error?) -> Void) {
        httpClient.getFlightInfo(requests: request, success: { (airports) in
            success(airports)
        }, failure: { error in
            if let error = error {
                failure(error)
                return
            }
        })
    }
    
    private func generateRequest(airportCode: String) -> [String:String]{
        return [:]
    }
    
    private func prepareToDisplay(data : [RawFlightInfo]) -> [FlightInfoToDisplay] {
        
        return []
    }
    
    private func getTime()->[String : String]{
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let dayInterval = 24*60*60-1.0
        let startOfDay = calendar.startOfDay(for: Date()).timeIntervalSince1970
        
        let endOfRequest = startOfDay + dayInterval
        let StartOfRequest = endOfRequest - dayInterval*3
        
        let end = String(format:"%f", endOfRequest)
        let start = String(format:"%f", StartOfRequest)
        
        return ["begin=" : start, "end=" : end]
        
    }
}
