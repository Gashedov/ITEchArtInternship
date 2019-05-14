//
//  MapViewModel.swift
//  AirportShedule
//
//  Created by student on 5/14/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation
import GoogleMaps

protocol MapViewModelDelegate: class {
    func dataReceived()
}

class MapViewModel {

    weak var delegate: MapViewModelDelegate?
    var data: GMSMutablePath
    var cameraPosition: GMSCameraPosition?
    private let flightTime: Int
    private let airplaneCode: String
    private let httpClient: HTTPClient

    init(flightTime: Int, airplaneCode: String ) {
        self.airplaneCode = airplaneCode
        self.flightTime = flightTime
        self.httpClient = HTTPClient()
        self.data = GMSMutablePath()
    }

    func getData() {
        httpClient.getTrackInfo(airplaneCode: airplaneCode, time: String(flightTime), success: { (track) in
            self.prepareToDisplay(track: track)
            self.delegate?.dataReceived()
        }) { (error) in
            NSLog(error.description)
        }
    }

    private func prepareToDisplay(track: Track) {
        let cameraLocation = CLLocationCoordinate2D(latitude: Double(track.path.first!.latitude!), longitude: Double(track.path.first!.longitude!))
        cameraPosition = GMSCameraPosition.camera(withLatitude: cameraLocation.latitude, longitude: cameraLocation.longitude, zoom: 3)
        data.removeAllCoordinates()
        for waypoint in track.path {
            data.add(CLLocationCoordinate2D(latitude: Double(waypoint.latitude!), longitude: Double(waypoint.longitude!)))
        }
    }
}
