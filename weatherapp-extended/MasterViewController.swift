//
//  MasterViewController.swift
//  weatherapp-extended
//
//  Created by plague on 11/1/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [CityWeatherItem]()
    
    let group = DispatchGroup()
    
    let warsawId: Int = 523920
    let londonId: Int = 44418
    let pragueId: Int = 796597

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        objects.insert(CityWeatherItem(id: warsawId, group: group), at: 0)
        objects.insert(CityWeatherItem(id: londonId, group: group), at: 1)
        objects.insert(CityWeatherItem(id: pragueId, group: group), at: 2)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        objects.insert(CityWeatherItem(id: 1132447, group: group), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as CityWeatherItem
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityWeatherCell

        self.group.wait()
        let object = objects[indexPath.row]
        cell.name!.text = object.weather!.title
        cell.temp!.text = String(format:"%.0f ºC", object.weather!.weatherElements![0].theTemp!)
        cell.icon!.image = UIImage(data: object.image!)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}
