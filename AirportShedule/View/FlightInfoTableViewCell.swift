//
//  FlightInfoableViewCell.swift
//  AirportShedule
//
//  Created by student on 4/23/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class FlightInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var airportNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setValues(name: String, arrivalTime: String, departureTime: String) {
        arrivalTimeLabel.text = "Arrival time: \(arrivalTime)"
        departureTimeLabel.text = "Departure time: \(departureTime)"
        airportNameLabel.text = "Airport: \(name)"
    }

}
