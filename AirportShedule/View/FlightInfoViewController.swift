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

    private var viewModel : FlightInfoViewModel!

    private var keys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FlightInfoViewModel(appDelegate:
            UIApplication.shared.delegate as? AppDelegate ?? AppDelegate(), dataType: flightType, airportCode: airportCode ?? "") // исправить 
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.delegate = self

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
        viewModel?.getData()
    }

    override func viewWillAppear(_ animated: Bool) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightInfoCell") as? FlightInfoTableViewCell else {
            return UITableViewCell()
        }
        let airport = viewModel?.data[viewModel.data.keys.sorted()[indexPath.section]]?[indexPath.row]
        //cell.setValues()
        return cell
    }
}

extension FlightInfoViewController: FlightsViewModelDelegate {
    func dataReceived() {
        tableView.reloadData()
        if viewModel.data.isEmpty {
            // видит что данные пустые и вызывает алерт
            self.present(alert, animated: true, completion: nil)
        }
    }
}
