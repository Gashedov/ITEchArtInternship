//
//  HTMLClient.swift
//  AirportTimetable
//
//  Created by student on 3/25/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

class HTTPClient {

    let baseFlightInfoPath = "https://opensky-network.org/api/flights/departure"

    private func parseRequest(requests: [String: String]) -> [URLQueryItem] {
        var items: [URLQueryItem] = []

        for (key, value) in requests {
            items.append(URLQueryItem(name: key, value: value))
        }
        return items
    }

    func getFlightInfo (requests: [String: String], success: @escaping ([RawFlightInfo]) -> Void,
                                                    failure: @escaping (_ error: Error?)-> Void) {

        var urlComponents = URLComponents(string: baseFlightInfoPath)
        urlComponents?.queryItems = parseRequest(requests: requests)

        guard let url = urlComponents?.url! else {
            return failure(NSError(domain: "", code: 404, userInfo: nil))
        }
        
        let urlRequest = URLRequest(url: url)

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: urlRequest) { (data, _, error) in

            guard error == nil else {
                failure(error!)
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            let flightInfo = try? JSONDecoder().decode([RawFlightInfo].self, from: responseData)
            DispatchQueue.main.async {
                success(flightInfo ?? [])
        }
        }
        task.resume()
    }

    func getAirportInfo(success: @escaping ([AirportInfo]) -> Void,
                        failure: @escaping (_ error: Error?)-> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/ram-nadella/airport-codes/master/airports.json") else {
            return failure(NSError(domain: "", code: 404, userInfo: nil))
        }

        let urlRequest = URLRequest(url: url)

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                failure(error!)
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            let airportInfo = try? JSONDecoder().decode([String: AirportInfo].self, from: responseData)
            DispatchQueue.main.async {
                success(airportInfo?.compactMap { $0.value } ?? [])
            }
        }
        task.resume()

    }
}
