//
//  DetailFlightInfoViewController.swift
//  AirportShedule
//
//  Created by student on 5/6/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class DetailFlightInfoViewController: UIViewController {

    @IBOutlet weak var planeImage: UIImageView!
    @IBOutlet weak var productionLineLabel: UILabel!
    @IBOutlet weak var planeModelLabel: UILabel!
    @IBOutlet weak var madelCodeLabel: UILabel!
    @IBOutlet weak var planeOwnerLabel: UILabel!
    @IBOutlet weak var planeAgeLabel: UILabel!
    @IBOutlet weak var registrarionCodeLabel: UILabel!

    private var airplaneCode: String?
    private var flightTime: Int?
    private var viewModel: DetailFlightInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let aircraftCode = airplaneCode else {
            return
        }

        viewModel = DetailFlightInfoViewModel(aircraftCode: aircraftCode)
        viewModel.delegate = self
        viewModel.getData()
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    func setAirplaneCode(code: String) {
        self.airplaneCode = code
    }

    func setFlightTime(time: Int) {
        self.flightTime = time
    }

    private func setImage() {
        planeImage.image = UIImage(data: viewModel.data.imageData!)
    }

    private func setLabels() {
        productionLineLabel.text = "Production line: \(viewModel.data.aircraft.productionLine ?? "N/A")"
        planeModelLabel.text = "Plane model: \(viewModel.data.aircraft.planeModel ?? "N/A")"
        madelCodeLabel.text = "Model code: \(viewModel.data.aircraft.modelCode ?? "N/A")"
        planeOwnerLabel.text = "Plane owner: \(viewModel.data.aircraft.planeOwner ?? "N/A")"
        planeAgeLabel.text = "Plane age: \(viewModel.data.aircraft.planeAge ?? "N/A")"
        registrarionCodeLabel.text = "Registration date: \(viewModel.data.aircraft.registrationDate ?? "N/A")"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let mapViewController = segue.destination as? MapViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        mapViewController.setProperties(time: flightTime!, airplaneCode: airplaneCode!)
    }

}

extension DetailFlightInfoViewController: DetailFlightInfoViewModelDelegate {
    func aircraftDataReceived() {
        setLabels()
    }
    func imageDataReceived() {
        setImage()
    }
}
