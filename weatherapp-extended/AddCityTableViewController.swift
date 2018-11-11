import UIKit
import CoreLocation

class AddCityTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    
    var objects = [CityItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.currentLocationButton.addTarget(self, action: #selector(currentLocationBtnClicked), for: UIControl.Event.touchUpInside)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameSearchId", for: indexPath)
        cell.textLabel!.text = objects[indexPath.row].title
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let object = objects[indexPath.row] as CityItem
            let controller = segue.destination as! MasterViewController
            controller.objects.insert(CityWeatherItem(id: object.id!, group: controller.group), at: 0)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            self.objects.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        let urlString = "https://www.metaweather.com/api/location/search/?query=" + searchText
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20"));
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            self.objects = try! JSONDecoder().decode([CityItem].self, from: d!);
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume();
    }
    
    let locationManager = CLLocationManager()
    
    @objc func currentLocationBtnClicked(sender: UIButton!){
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        print(currentLocation)
        let latlong = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        let urlString = "https://www.metaweather.com/api/location/search/?lattlong=" + latlong
        
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20"));
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            self.objects = try! JSONDecoder().decode([CityItem].self, from: d!);
            
            DispatchQueue.main.async {
                if (self.objects.count != 0) {
                    self.showToast(message: "Closest location: " + self.objects[0].title!)
                }
                self.tableView.reloadData()
            }
        }.resume();
        
    }
    
    //source of this method - https://stackoverflow.com/questions/31540375/how-to-toast-message-in-swift
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: 700, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
}
