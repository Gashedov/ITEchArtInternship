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
    private var airplaneCode: String = ""
    private var viewModel: DetailFlightInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailFlightInfoViewModel(aircraftCode: airplaneCode)
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    func setAirplaneCode(code: String) {
        self.airplaneCode = code
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
