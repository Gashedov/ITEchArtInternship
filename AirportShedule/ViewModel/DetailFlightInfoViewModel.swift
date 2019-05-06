//
//  DetailFlightInfoViewModel.swift
//  AirportShedule
//
//  Created by student on 5/6/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

protocol DetailFlightInfoViewModelDelegate: class {
    func dataReceived()
}

class DetailFlightInfoViewModel {

    weak var delegate: DetailFlightInfoViewModelDelegate?
    let httpclient: HTTPClient
    var data: (imageData: Data?, aircraft: Aircraft)
    let aircraftCode: String

    init(aircraftCode: String) {
        httpclient = HTTPClient()
        self.aircraftCode = aircraftCode
        data = (Data(),Aircraft(productionLine: "",
                                planeModel: "",
                                modelCode: "",
                                registrationDate: "",
                                planeAge: "",
                                planeOwner: ""))
    }

    func getData() {
        // check seccuseed
        getAircraftInfo(code: aircraftCode)
        getImage(code: aircraftCode)
    }

    // MARK: - Private functions

    private func getAircraftInfo(code: String) {
        httpclient.getAircraftInfo(icao: code, success: { aircraft in
                self.data.aircraft = aircraft
        }) { error in
            NSLog("Error: \(String(describing: error.description))")
        }
    }

    private func getImage(code: String) {
        httpclient.getPlaneImage(icao: code, success: { (data) in
            if let imageData = data {
                self.data.imageData = imageData
            }
        }) { error in
            NSLog("Error: \(String(describing: error.description))")
        }
    }
}
