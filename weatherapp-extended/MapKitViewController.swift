import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 500 * 1000
    
    var cityName: String?
    
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.centerMapOnLocation(location: self.location!)
        self.putAtwork(title: self.cityName!, location: self.location!)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func putAtwork(title: String, location: CLLocationCoordinate2D) {
        let annotation = Pin(title: title, coordinate: location)
        mapView.addAnnotation(annotation)
    }
}

class Pin: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
