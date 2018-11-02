import UIKit

class AddCityTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var objects = [CityItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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

}
