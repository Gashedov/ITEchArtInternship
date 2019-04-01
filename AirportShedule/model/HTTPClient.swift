//
//  HTMLClient.swift
//  AirportTimetable
//
//  Created by student on 3/25/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

class HTTPClient{
    
    let baseFlightInfoPath = "https://opensky-network.org/api/flights/departure"
    
    private func parseRequest(requests: [String : String]) -> [URLQueryItem]{
        var items = [URLQueryItem]()
        
        for (key, value) in requests{
            items.append(URLQueryItem(name: key,value: value))
        }
        return items
    }
    
    func getCommonFlightInfo (requests: [String : String], callback: @escaping ([CommonFlightInfo] , Error?) -> Void) {
        
        var url = URLComponents(string: baseFlightInfoPath)
        url?.queryItems = parseRequest(requests: requests)
        
        let urlRequest = URLRequest(url: (url?.url)!)
     
        let session = URLSession(configuration: .default)
        
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
           
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let flightInfo = try! JSONDecoder().decode([CommonFlightInfo].self, from: responseData)
            DispatchQueue.main.async {
            callback(flightInfo, nil)
        }
        }
        task.resume()
    }
    
    func getAirportInfo(callback: @escaping ([AirportInfo] , Error?) -> Void){
        guard let url = URL(string: "https://raw.githubusercontent.com/ram-nadella/airport-codes/master/airports.json") else{return callback([],nil)}
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let airportInfo = try! JSONDecoder().decode([String: AirportInfo].self, from: responseData)
            DispatchQueue.main.async {
                callback(airportInfo.compactMap{ $0.value }, nil)
            }
           
        }
        task.resume()
        
    }
}


