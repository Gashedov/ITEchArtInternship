//
//  TimetableViewController.swift
//  AirportShedule
//
//  Created by student on 3/28/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class SheduleTableViewController: UITableViewController {

    let viewModel = AirportsViewModel(appDelegate: UIApplication.shared.delegate as? AppDelegate ?? AppDelegate())

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
        if viewModel.data[section].isOpen {
            return viewModel.data[section].sectionObject.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.data[section].sectionName
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
        for row in viewModel.data[section].sectionObject.indices{
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleTableViewCell") as? TimetableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor.gray
        
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension SheduleTableViewController: AirportsViewModelDelegate {
    func receiveddData() {
        tableView.reloadData()
        print(viewModel.data)
    }
}


