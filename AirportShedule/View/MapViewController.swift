//
//  MapViewController.swift
//  AirportShedule
//
//  Created by student on 5/14/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    private var flightTime: Int?
    private var airplaneCode: String?
    private var viewModel: MapViewModel!
    private var mapView: GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MapViewModel(flightTime: flightTime!, airplaneCode: airplaneCode!)
        GMSServices.provideAPIKey("AIzaSyBRn2GZsZo3ZMkpwuDOX328PfbdojfpdPA")

        let camera = GMSCameraPosition.camera(withLatitude: 18.520, longitude: 73.856, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getData()
    }

    func setProperties(time: Int, airplaneCode: String) {
        self.airplaneCode = airplaneCode
        self.flightTime = time
    }

    func buildARoute() {
        let path = viewModel.data
        mapView?.camera = viewModel.cameraPosition!
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapView
    }
}

extension MapViewController: MapViewModelDelegate {
    func dataReceived() {
        buildARoute()
    }
}
