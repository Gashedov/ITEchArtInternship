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
    
    private var airplaneCode: String = ""
    private var viewModel: DetailFlightInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailFlightInfoViewModel(aircraftCode: airplaneCode)
        viewModel.delegate = self
        viewModel.getData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
    }

    func setAirplaneCode(code: String) {
        self.airplaneCode = code
    }

    private func setImage() {
        planeImage.image = UIImage(data: viewModel.data.imageData!)
    }

    private func setLabels() {
        productionLineLabel.text = "Production line: \(String(describing: viewModel.data.aircraft.productionLine))"
        planeModelLabel.text = "Plane model: \(String(describing: viewModel.data.aircraft.planeModel))"
        madelCodeLabel.text = "Model code: \(String(describing: viewModel.data.aircraft.modelCode))"
        planeOwnerLabel.text = "Plane owner: \(String(describing: viewModel.data.aircraft.planeOwner))"
        planeAgeLabel.text = "Plane age: \(String(describing: viewModel.data.aircraft.planeAge))"
        registrarionCodeLabel.text = "Registration date: \(String(describing: viewModel.data.aircraft.registrationDate))"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailFlightInfoViewController: DetailFlightInfoViewModelDelegate {
    func aircraftDataReceived() {
        setLabels()
    }
    func imageDataReceived() {
        setImage()
    }
}
