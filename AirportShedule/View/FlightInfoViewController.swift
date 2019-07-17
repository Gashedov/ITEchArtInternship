//
//  FlightInfoViewController.swift
//  AirportShedule
//
//  Created by student on 4/23/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class FlightInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var alert: UIAlertController = UIAlertController()
    var flightType: FlightType!
    var airportCode: String?

    private var viewModel: FlightInfoViewModel!

    private var keys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FlightInfoViewModel(appDelegate:
            UIApplication.shared.delegate as? AppDelegate ?? AppDelegate(),
                                        dataType: flightType, airportCode: airportCode ?? "") // исправить

        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.delegate = self

        alert = UIAlertController(title: "Sorry",
                                  message: "This airport does't provide information about flihgts",
                                  preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                self.navigationController?.popViewController(animated: true)
                NSLog("Allert default action сoused")

            case .cancel:
                NSLog("Allert cancel action coused")

            case .destructive:
                NSLog("Allert destructive action coused")

            }}))

        viewModel?.getData()
    }

// MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return viewModel?.data.keys.sorted()[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data[viewModel.data.keys.sorted()[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightInfoCell")
            as? FlightInfoTableViewCell else {
            return UITableViewCell()
        }
        let airport = viewModel?.data[viewModel.data.keys.sorted()[indexPath.section]]?[indexPath.row]
        cell.setValues(name: airport?.airportName ?? "N/A",
                       arrivalTime: airport?.arrivalTime ?? "N/A",
                       departureTime: airport?.departureTime ?? "N/A")
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let detailInfoViewController = segue.destination as? DetailFlightInfoViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        guard let selectedAirportCell = sender as? FlightInfoTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }

        guard let indexPath = tableView.indexPath(for: selectedAirportCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }

        if let selectedFlight = viewModel.getFlight(by: indexPath) {
            detailInfoViewController.setAirplaneCode(code: selectedFlight.code)
            detailInfoViewController.setFlightTime(time: selectedFlight.time)
        }

    }
}

// MARK: - Extensions

extension FlightInfoViewController: FlightsViewModelDelegate {
    func dataReceived() {
        tableView.reloadData()
        if viewModel.data.isEmpty {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
