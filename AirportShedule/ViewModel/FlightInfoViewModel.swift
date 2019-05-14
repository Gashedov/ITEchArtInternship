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

    var data = [String: [FlightInfoToDisplay]]()

    private var rawData = [RawFlightInfo]()
    private var airports = [AirportInfo]()
    private let httpClient: HTTPClient
    private let coreDataManager: CoreDataManager
    private let dateManager: DateManager
    private let dataType: FlightType
    private let airportCode: String

    private var group: DispatchGroup?

    init(appDelegate: AppDelegate, dataType: FlightType, airportCode: String) {
        coreDataManager = CoreDataManager(appDelegate: appDelegate)
        httpClient = HTTPClient()
        dateManager = DateManager()
        self.dataType = dataType
        self.airportCode = airportCode
        group = DispatchGroup()
    }

    func getData() {
        getRawData()
        getAirports()

        group?.notify(queue: DispatchQueue.main, execute: {
            self.prepareToDisplay()
            self.delegate?.dataReceived()
        })
    }

    func getFlight(by index: IndexPath) -> FlightInfoToDisplay? {
        let key = data.keys.sorted()[index.section]
        if let airport = data[key]?[index.row] {
            return airport
        }

        return nil
    }

    // MARK: - private methods

    private func getRawData() {
        let request = generateRequest(airportCode: airportCode)
        let type = dataType == .arrival ? OpenSkyAPIRequestPath.arrivalRequest : OpenSkyAPIRequestPath.departureRequest

        group?.enter()
        httpClient.getFlightInfo(requestType: type, components: request, success: { data in
            self.group?.leave()
            self.rawData = data
        }, failure: { error in
            NSLog("Error: \(String(describing: error.description))")
        })
    }

    private func getAirports() {
        group?.enter()
        coreDataManager.loadDataFromDB(success: { data in
            self.group?.leave()
            self.airports = data
        }, failure: { error in
            NSLog("Error: \(String(describing: error.description))")
        })
    }

    private func generateRequest(airportCode: String) -> [String: String] {
        let timeInterval = dateManager.getTime()
        let end = String(timeInterval.end)
        let begin = String(timeInterval.begin)
        let request = ["airport": airportCode, "begin": begin, "end": end]

        return request
    }

    private func prepareToDisplay() {
        var result: [String: [FlightInfoToDisplay]] = [:]

        for flightInfo in rawData {
            let arrivalTime = dateManager.convertTimeToString(time: flightInfo.arrivalTime ?? 0)
            let departureTime = dateManager.convertTimeToString(time: flightInfo.departureTime ?? 0)
            var airportName = "N/A"

            let lookingCode = dataType == .arrival ? flightInfo.departureAirportCode : flightInfo.arrivalAirportCode

            if let code = lookingCode {
                airportName = airports.first(where: { $0.code == code })?.name ?? "N/A"
            }
            var key = ""
            var time = 0

            switch dataType {
            case .arrival:
                key = dateManager.convertDateToString(time: flightInfo.arrivalTime ?? 0)
                time = flightInfo.arrivalTime! - 10
            case .departure:
                key = dateManager.convertDateToString(time: flightInfo.departureTime ?? 0)
                time = flightInfo.departureTime! - 10
            }

            if result[key] != nil {
                result[key]?.append(FlightInfoToDisplay(airportName: airportName,
                                                        arrivalTime: arrivalTime,
                                                        departureTime: departureTime,
                                                        code: flightInfo.code,
                                                        time: time))
            } else {
                result[key] = [FlightInfoToDisplay(airportName: airportName,
                                                   arrivalTime: arrivalTime,
                                                   departureTime: departureTime,
                                                   code: flightInfo.code,
                                                   time: time)]
            }
        }

        data = result
    }

    private func getAirportFromCoreData(identifier: String,
                                        success: @escaping (_ data: String) -> Void) {
        coreDataManager.getAirport(byIdentifier: identifier, result: { coreDataAirport in
                success(coreDataAirport.name ?? "Nil")
        })
    }
}
