//
//  TimetableViewController.swift
//  AirportShedule
//
//  Created by student on 3/28/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class SheduleTableViewController: UITableViewController {
    
    
    var objectArray = [SheduleInfoToDisplay]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectArray = cdManager.loadDataFromDB()
        if objectArray.isEmpty{
            setData()
            objectArray = cdManager.loadDataFromDB()
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objectArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if objectArray[section].isOpen == true{
            return objectArray[section].sectionObject.count
        }
        else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleTableViewSectionCell") as? TableViewSectionCell else{return UITableViewCell()}
            cell.textLabel?.text = objectArray[indexPath.section].sectionName
            cell.backgroundColor = UIColor.gray
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleTableViewCell") as? TimetableViewCell else{return UITableViewCell()}
            //cell.textLabel?.text = objectArray[indexPath.section].sectionObject[indexPath.row]
            cell.backgroundColor = UIColor.white
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objectArray[indexPath.section].isOpen == true{
            objectArray[indexPath.section].isOpen = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        else{
            objectArray[indexPath.section].isOpen = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
    private func setData(){
        let service = AirportsService()
//        service.syncAirportsIfNeeded(callback: <#T##(Bool) -> ()#>)
        
        
        let client = HTTPClient()
        client.getAirportInfo { [weak self] (airports , errors) in
            let parser = Parser()
            let data = parser.prepareDataForDisplay(objects: airports)
            
            self?.objectArray = data
            self?.cdManager.saveAirports(airports: data)
            self?.tableView.reloadData()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
