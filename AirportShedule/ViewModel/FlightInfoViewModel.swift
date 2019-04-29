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

    var data: [String: [FlightInfoToDisplay]]
    private let httpClient: HTTPClient
    private let coreDataManager: CoreDataManager
    private let dateManager: DateManager
    private let dataType: FlightType
    private let airportCode: String

    init(appDelegate: AppDelegate, dataType: FlightType, airportCode: String) {
        coreDataManager = CoreDataManager(appDelegate: appDelegate)
        data = [:]
        httpClient = HTTPClient()
        dateManager = DateManager()
        self.dataType = dataType
        self.airportCode = airportCode
    }

    func getData() {

        let request = generateRequest(airportCode: airportCode)

        switch dataType {
        case .arrival:
            self.getDataFromNetwork(path: .arrivalRequest, uponRequestParametrs: request, success: { data in
                self.data = self.prepareToDisplay(data: data)
                self.delegate?.dataReceived()

            }, failure: { error in
                print("Error: \(String(describing: error))")
            })
        case .departure:
            self.getDataFromNetwork(path: .departureRequest, uponRequestParametrs: request, success: { data in
                self.data = self.prepareToDisplay(data: data)
                self.delegate?.dataReceived()

            }, failure: { error in
                print("Error: \(String(describing: error))")
            })
        }

    }

    // MARK: - private methods

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

    private func generateRequest(airportCode: String) -> [String: String] {
        let timeInterval = dateManager.getTime()
        let end = String(timeInterval.end)
        let begin = String(timeInterval.begin)
        let request = ["airport": airportCode, "begin": begin, "end": end]

        return request
    }

    private func prepareToDisplay(data: [RawFlightInfo]) -> [String: [FlightInfoToDisplay]] {
        var result: [String: [FlightInfoToDisplay]] = [:]

        for flightInfo in data {

            let arrivalTime = dateManager.convertTimeToString(time: flightInfo.arrivalTime ?? 0)
            let departureTime = dateManager.convertTimeToString(time: flightInfo.departureTime ?? 0)
            var airportName = ""
            var key = ""

            switch dataType {
            case .arrival:
                coreDataManager.getAirport(byIdentifier: flightInfo.arrivalAirportCode ?? "", result: { coreDataAirport in
                    airportName = coreDataAirport.name ?? ""
                    })
                key = dateManager.convertDateToString(time: flightInfo.arrivalTime ?? 0)
            case .departure:
                coreDataManager.getAirport(byIdentifier: flightInfo.departureAirportCode ?? "", result: { coreDataAirport in
                    airportName = coreDataAirport.name ?? ""
                    })
                key = dateManager.convertDateToString(time: flightInfo.departureTime ?? 0)
            }

            if result[key] != nil {
                result[key]?.append(FlightInfoToDisplay(airportName: airportName, arrivalTime: arrivalTime, departureTime: departureTime))
            } else {
                result[key] = [FlightInfoToDisplay(airportName: airportName, arrivalTime: arrivalTime, departureTime: departureTime)]
            }
        }
        return result
    }
}
