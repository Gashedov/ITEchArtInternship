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
    
    private let viewModel = FlightInfoViewModel(appDelegate: UIApplication.shared.delegate as? AppDelegate ?? AppDelegate())
    private var keys = Array<String>()
    private var airportCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keys = Array(viewModel.data.keys)
        keys.sort(by: >)
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(airportCode)
        viewModel.getData(airportCode: airportCode)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return keys[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data[keys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightInfoCell") as? FlightInfoTableViewCell else {
            return UITableViewCell()
        }
        let airport = viewModel.data[keys[indexPath.section]]?[indexPath.row]
        //cell.setValues()
        return cell
    }
    
    func setAirportCode(code: String) {
        airportCode = code 
    }
    
    @IBAction func switchType(_ sender: UISegmentedControl) {
        print("Switched")
    }
}

extension FlightInfoViewController: FlightsViewModelDelegate {
    func dataReceived() {
        tableView.reloadData()
        print(viewModel.data.isEmpty ? "data is empty" : "data updated")
    }    
}
