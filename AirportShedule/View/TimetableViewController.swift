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
    
    var searchingCountry = [SheduleInfoToDisplay]()

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
            return searchingCountry.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingCountry[section].isOpen {
            return viewModel.data[section].sectionObject.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.data[section].sectionName, for: .normal)
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
        for row in viewModel.data[section].sectionObject.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        if viewModel.data[section].isOpen {
            viewModel.data[section].isOpen = false
            tableView.deleteRows(at: indexPaths, with: .none)
        } else {
            viewModel.data[section].isOpen = true
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
            let airport = viewModel.data[indexPath.section].sectionObject[indexPath.row]
            cell.setValues(code: airport.code, city: airport.city ?? "", name: airport.airportName ?? "")
        
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension SheduleTableViewController: AirportsViewModelDelegate {
    func receiveddData() {
        searchingCountry = viewModel.data
        tableView.reloadData()
        print(viewModel.data.isEmpty ? "is empty" : "data recieved")
    }
}

extension SheduleTableViewController: UISearchResultsUpdating {
    // calls every time you interact with search bar
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text!.isEmpty {
            searchingCountry = viewModel.data.filter({$0.sectionName.prefix(searchController.searchBar.text!.count) == searchController.searchBar.text!})
        } else {
            searchingCountry = viewModel.data
        }
        tableView.reloadData()
    }
}

