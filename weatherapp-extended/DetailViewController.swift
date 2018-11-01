//
//  DetailViewController.swift
//  weatherapp-extended
//
//  Created by plague on 11/1/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.weather?.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: CityWeatherItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

