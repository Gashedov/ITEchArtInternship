//
//  AirportService.swift
//  AirportShedule
//
//  Created by student on 4/4/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation
import UIKit

// 1. check db - return
// 2. request
//  2.1 parse
//    2.2.0 remova all from core data
//  2.2 store to core data
// 3. take from db
class AirportsService {
    
    let cdManager = CoreDataManager(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    
    func getAirpots(callback: @escaping (PreparedAirportsList) -> Void) {
        
    var airportList = cdManager.loadDataFromDB()
        
    }
    

}
