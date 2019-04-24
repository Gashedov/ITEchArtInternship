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

    private let viewModel = FlightInfoViewModel(appDelegate:
        UIApplication.shared.delegate as? AppDelegate ?? AppDelegate())

    private var keys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self

        alert = UIAlertController(title: "Sorry", message: "This airport does't provide information about flihgts", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")

            }}))
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getData()
//        keys = viewModel.data.keys.sorted()
//        keys.sort(by: >)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return viewModel.data.keys.sorted()[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data[viewModel.data.keys.sorted()[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightInfoCell") as? FlightInfoTableViewCell else {
            return UITableViewCell()
        }
        let airport = viewModel.data[viewModel.data.keys.sorted()[indexPath.section]]?[indexPath.row]
        //cell.setValues()
        return cell
    }

    func setAirportCode(code: String) {
        viewModel.airportCode = code
    }

    @IBAction func switchType(_ sender: UISegmentedControl) {
        // works when segmentedControl switches to other side
        //start indicator
        viewModel.switchType()
    }
}

extension FlightInfoViewController: FlightsViewModelDelegate {
    func dataReceived() {
        tableView.reloadData()
        if viewModel.data.isEmpty { // and indicator not active
            self.present(alert, animated: true, completion: nil)
        }
    }
}
