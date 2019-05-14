//
//  TimetableViewController.swift
//  AirportShedule
//
//  Created by student on 3/28/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class SheduleTableViewController: UIViewController {

    private let viewModel = AirportsViewModel(appDelegate: UIApplication.shared.delegate as? AppDelegate ?? AppDelegate())
    private let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getData()
    }

    @objc func hendleExpandClose(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in viewModel.dataToDisplay[section].airportAttributs.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }

        if viewModel.dataToDisplay[section].isOpen {
            viewModel.dataToDisplay[section].isOpen = false
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            viewModel.dataToDisplay[section].isOpen = true
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let flightInfoViewController = segue.destination as? MasterFlighInfoViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        guard let selectedAirportCell = sender as? TimetableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }

        guard let indexPath = tableView.indexPath(for: selectedAirportCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }

        let selectedAirport = viewModel.dataToDisplay[indexPath.section].airportAttributs[indexPath.row].code
        flightInfoViewController.setAirportCode(code: selectedAirport)

    }
}

extension SheduleTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.dataToDisplay.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataToDisplay[section].isOpen {
            return viewModel.dataToDisplay[section].airportAttributs.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableViewCellReuseIdentifier", for: indexPath) as! TimetableViewCell
        let airport = viewModel.dataToDisplay[indexPath.section].airportAttributs[indexPath.row]
        cell.setValues(code: airport.code, city: airport.city ?? "", name: airport.airportName ?? "")
        return cell
    }
}

extension SheduleTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.dataToDisplay[section].airportCountry, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.textAlignment = .left
        button.tag = section
        button.addTarget(self, action: #selector(hendleExpandClose), for: .touchUpInside)

        return button
    }
}

extension SheduleTableViewController: AirportsViewModelDelegate {
    func receivedData() {
        tableView.reloadData()
        NSLog(viewModel.dataToDisplay.isEmpty ? "data is empty" : "data updated")
    }
}

extension SheduleTableViewController: UISearchResultsUpdating {
    // calls every time you interact with search bar
    func updateSearchResults(for searchController: UISearchController) {
            viewModel.searchCountry(searchingCountry: searchController.searchBar.text!)
    }
}
