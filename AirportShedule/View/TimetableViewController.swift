//
//  TimetableViewController.swift
//  AirportShedule
//
//  Created by student on 3/28/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class SheduleTableViewController: UITableViewController {
    
    private let viewModel = AirportsViewModel(appDelegate: UIApplication.shared.delegate as? AppDelegate ?? AppDelegate())
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
            return viewModel.dataToDisplay.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataToDisplay[section].isOpen {
            return viewModel.dataToDisplay[section].airportAttributs.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.dataToDisplay[section].airportCountry, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.textAlignment = .left
        button.tag = section
        button.addTarget(self, action: #selector(hendleExpandClose), for: .touchUpInside)
        
        return button
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
            tableView.deleteRows(at: indexPaths, with: .none)
        } else {
            viewModel.dataToDisplay[section].isOpen = true
            tableView.insertRows(at: indexPaths, with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableViewCell") as? TimetableViewCell else {
                return UITableViewCell()
            }
        let airport = viewModel.dataToDisplay[indexPath.section].airportAttributs[indexPath.row]
            cell.setValues(code: airport.code, city: airport.city ?? "", name: airport.airportName ?? "")
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension SheduleTableViewController: AirportsViewModelDelegate {
    func receivedData() {
        //searchingCountry = viewModel.data
        tableView.reloadData()
        print(viewModel.dataToDisplay.isEmpty ? "data is empty" : "data updated")
    }
}

extension SheduleTableViewController: UISearchResultsUpdating {
    // calls every time you interact with search bar
    func updateSearchResults(for searchController: UISearchController) {
            viewModel.searchCountry(searchingCountry: searchController.searchBar.text!)
    }
}
