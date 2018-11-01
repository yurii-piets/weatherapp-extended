import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UINavigationItem!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var himidityLabel: UILabel!
    @IBOutlet weak var airPressureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var currentWeatherId:Int = 0
    
    func configureView() {
        if let detail = detailItem {
            self.cityNameLabel.title = detail.weather!.title;
            self.dateLabel.text = detail.weather!.weatherElements![self.currentWeatherId].applicableDate;
            self.minTempLabel.text = String(format:"%.0f ºC", detail.weather!.weatherElements![self.currentWeatherId].minTemp!)
            self.maxTempLabel.text = String(format:"%.0f ºC", detail.weather!.weatherElements![self.currentWeatherId].maxTemp!)
            self.windSpeedLabel.text = String(format:"%.0f km/h", detail.weather!.weatherElements![self.currentWeatherId].windSpeed!)
            self.windDirLabel.text = detail.weather!.weatherElements![self.currentWeatherId].windDirectionCompass!
            self.himidityLabel.text = "\(detail.weather!.weatherElements![self.currentWeatherId].humidity!)" + "%"
            self.airPressureLabel.text = String(format:"%.0f", detail.weather!.weatherElements![self.currentWeatherId].airPressure!) + " mbar"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prevBtn.isEnabled = false
        self.configureView()
        self.initTargets()
        self.loadIcon()
    }

    var detailItem: CityWeatherItem? {
        didSet {
        }
    }
    
    func initTargets(){
        self.prevBtn.addTarget(self, action: #selector(prevBtnClicked), for: UIControl.Event.touchUpInside)
        self.nextBtn.addTarget(self, action: #selector(nextBtnClicked), for: UIControl.Event.touchUpInside)
    }

    @objc func prevBtnClicked(sender: UIButton!){
        self.currentWeatherId -= 1
        self.configureView()
        self.loadIcon()
        if(self.currentWeatherId <= 0) {
            self.prevBtn.isEnabled = false
        }
        self.nextBtn.isEnabled = true
    }
    
    @objc func nextBtnClicked(sender: UIButton!){
        self.currentWeatherId += 1
        self.configureView()
        self.loadIcon()
        if(self.currentWeatherId >= detailItem!.weather!.weatherElements!.count - 1) {
            self.nextBtn.isEnabled = false
        }
        self.prevBtn.isEnabled = true
    }
    
    func loadIcon(){
        let abbr = detailItem!.weather!.weatherElements![self.currentWeatherId].weatherStateAbbr!;
        let iconUrl = "https://www.metaweather.com/static/img/weather/png/64/" + abbr + ".png"
        
        let url = URL(string: iconUrl);
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            
            if let err = err {
                print("Unexpected \(err)");
                return;
            }
            
            DispatchQueue.main.async {
                self.weatherIcon.image = UIImage(data: d!)
            }
            }.resume();
    }
}

