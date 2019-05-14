//
//  TimetableViewCell.swift
//  AirportShedule
//
//  Created by student on 3/28/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

class TimetableViewCell: UITableViewCell {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // swiftlint:disable line_length
    func setValues(code: String, city: String, name: String) {
        codeLabel.text = "Code: \(code)"
        cityLabel.text = "City: \(city)"
        nameLabel.text = "Name: \(name)"
    }
}
