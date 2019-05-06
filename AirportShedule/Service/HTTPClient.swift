//
//  HTMLClient.swift
//  AirportTimetable
//
//  Created by student on 3/25/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

enum OpenSkyAPIRequestPath: String {
    case departureRequest = "flights/departure"
    case arrivalRequest =  "flights/arrival"
}

enum HTTPClientError: Error {
    case urlGettingError
    case sessionDataTaskError
    case emptyDataTaskError

    var description: String {
        switch self {
        case .urlGettingError:
            return "Could not generate url"
        case .sessionDataTaskError:
            return "Data task throw an error"
        case .emptyDataTaskError:
            return "Could not get data from data task"
        }
    }
}

class HTTPClient {

    private let baseFlightInfoPath = "https://opensky-network.org/api/"
    
    private let imageBaseUrl = "https://api.unsplash.com"
    private let imagePath = "/photos/random"
    private let imageAccessKey = "397c50b762e28cf9b1da268b8389df3c6a109b06e11668a2a20ba3a3a35ed575"
    private static let imageCache = NSCache<NSString, NSData>()
    
    private let aicraftBaseUrl = "https://aviation-edge.com/v2/public"
    private let aircraftPath = "/airplaneDatabase"
    private let aircraftAccessKey = "e3d452-749de5"

    func getFlightInfo (requestType: OpenSkyAPIRequestPath, components: [String: String], success: @escaping ([RawFlightInfo]) -> Void,
                                                    failure: @escaping (HTTPClientError) -> Void) {
        let basePath = baseFlightInfoPath + requestType.rawValue
        var urlComponents = URLComponents(string: basePath)
        urlComponents?.queryItems = parseRequest(requests: components)

        guard let url = urlComponents?.url! else {
            return failure(.urlGettingError)
        }

        let urlRequest = URLRequest(url: url)
        NSLog("Url genereted: \(urlRequest)")
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: urlRequest) { (data, _, error) in

            guard error == nil else {
                failure(.sessionDataTaskError)
                return
            }

            guard let responseData = data else {
                failure(.emptyDataTaskError)
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
                        failure: @escaping (HTTPClientError) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/ram-nadella/airport-codes/master/airports.json") else {
            return failure(.urlGettingError)
        }

        let urlRequest = URLRequest(url: url)

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                failure(.sessionDataTaskError)
                return
            }

            guard let responseData = data else {
                failure(.emptyDataTaskError)
                return
            }

            let airportInfo = try? JSONDecoder().decode([String: AirportInfo].self, from: responseData)
            DispatchQueue.main.async {
                success(airportInfo?.compactMap { $0.value } ?? [])
            }
        }
        task.resume()
    }

    func getAircraftInfo(icao: String, success: @escaping (Aircraft) -> Void,
                         failure: @escaping (HTTPClientError) -> Void) {
        
        let paramPath = buildParamAircraftPath(key: aircraftAccessKey, icao: icao)
        
        guard let url = URL(string: aicraftBaseUrl + aircraftPath + paramPath) else {
            DispatchQueue.main.async {
                failure(.urlGettingError)
            }
            return
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in

            guard let data = data else {
                DispatchQueue.main.async {
                    failure(.emptyDataTaskError)
                }
                return
            }
            
            guard let aircraft = try? JSONDecoder().decode([Aircraft].self, from: data) else {
                DispatchQueue.main.async {
                    failure(.sessionDataTaskError) // codable error
                }
                return
            }

            DispatchQueue.main.async {
                success(aircraft.first!)
            }
        }
        task.resume()
    }
    
    func getPlaneImage(icao: String, success: @escaping (Data?) -> Void,
                       failure: @escaping (HTTPClientError) -> Void) {

        if let cachedImage = HTTPClient.imageCache.object(forKey: icao as NSString) {
            success(cachedImage as Data)
            return
        }

        let paramPath = buildParamImagePath(query: "Airplane", orientation: .landscape)

        // create full URL
        guard let url = URL(string: imageBaseUrl + imagePath + paramPath) else {
            failure(.urlGettingError)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID \(imageAccessKey)", forHTTPHeaderField: "Authorization")

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(.emptyDataTaskError)
                }
                return
            }

            // get image url
            guard let image = try? JSONDecoder().decode(Image.self, from: data) else {
                DispatchQueue.main.async {
                    failure(.emptyDataTaskError) // ImageError
                }
                return
            }
            // create image url from string
            guard let imageUrl = URL(string: image.urls.small) else {
                DispatchQueue.main.async {
                    failure(.urlGettingError)
                }
                return
            }

            if let data = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    HTTPClient.imageCache.setObject(data as NSData, forKey: icao as NSString)
                    success(data)
                }
            }
        }
        task.resume()
    }

    // MARK: - private methods

    private func parseRequest(requests: [String: String]) -> [URLQueryItem] {
        var items: [URLQueryItem] = []

        for (key, value) in requests {
            items.append(URLQueryItem(name: key, value: value))
        }
        return items
    }

    private func buildParamImagePath(query: String, orientation: Orientation) -> String {
        var components = URLComponents()

        let queryItem = URLQueryItem(name: "query", value: query)
        let queryItemOrientation = URLQueryItem(name: "orientation", value: orientation.rawValue)

        components.queryItems = [queryItem, queryItemOrientation]

        guard let paramPath = components.url else {
            fatalError("Parameter generation error")
        }

        return paramPath.description
    }
    
    private func buildParamAircraftPath(key: String, icao: String) -> String {
        var components = URLComponents()

        let queryItemKey = URLQueryItem(name: "key", value: key)
        let queryItemIcao = URLQueryItem(name: "hexIcaoAirplane", value: icao.uppercased())
        
        components.queryItems = [queryItemKey, queryItemIcao]
        
        guard let paramPath = components.url else {
            fatalError("Parameter generation error")
        }
        
        return paramPath.description
    }
}
