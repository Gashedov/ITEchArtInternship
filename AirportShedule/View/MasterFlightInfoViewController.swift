//
//  MasterViewController.swift
//  AirportShedule
//
//  Created by student on 4/29/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import UIKit

enum FlightType: CaseIterable {
    case arrival
    case departure
}

class MasterFlighInfoViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var embededView: UIView!
    var airportCode: String = ""
    var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        FlightType.allCases.forEach { type in
            if let controller = prepareViewController(type) {
                self.controllers.append(controller)
            }
        }

        add(asChildViewController: controllers[0])
    }

    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    func setAirportCode(code: String) {
        airportCode = code
    }

// MARK: - Private methods

    private func prepareViewController(_ flightType: FlightType) -> FlightInfoViewController? {
        guard let controller = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "FlightInfoViewController") as? FlightInfoViewController else {
            return nil
        }
        // sending the necessary information
        controller.airportCode = self.airportCode
        controller.flightType = flightType

        return controller
    }

    private func setupView() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Arrival", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Departure", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)

        segmentedControl.selectedSegmentIndex = 0
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)

        view.addSubview(viewController.view)

        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: self)
    }

    private func removeAllViewControllers() {
        // this function will need refactoring if the controllers implement viewWillAppear()
        for viewController in controllers {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }

    private func updateView() {
        removeAllViewControllers()
        add(asChildViewController: controllers[segmentedControl.selectedSegmentIndex])
    }
}
