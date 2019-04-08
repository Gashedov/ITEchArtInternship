//
//  TimetableViewController.swift
//  AirportShedule
//
//  Created by student on 3/28/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class SheduleTableViewController: UITableViewController {

    let viewModel = AirportsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if objectArray[section].isOpen == true {
//            return objectArray[section].sectionObject.count
//        } else {
//            return 1
//        }
        
        return viewModel.data[section].sectionObject.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.data[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleTableViewSectionCell") as? TableViewSectionCell else {
//                return UITableViewCell()
//            }
//
//ç            cell.backgroundColor = UIColor.gray
//            return cell
//        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleTableViewCell") as? TimetableViewCell else {
                return UITableViewCell()
            }
            //cell.textLabel?.text = objectArray[indexPath.section].sectionObject[indexPath.row]
            cell.backgroundColor = UIColor.white
        
            return cell

//        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if objectArray[indexPath.section].isOpen == true {
//            objectArray[indexPath.section].isOpen = false
//            let sections = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(sections, with: .none)
//        } else {
//            objectArray[indexPath.section].isOpen = true
//            let sections = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(sections, with: .none)
//        }
    }
}

extension SheduleTableViewController: AirportsViewModelDelegate {
    func receiveddData() {
        tableView.reloadData()
        print(viewModel.data)
    }
}
