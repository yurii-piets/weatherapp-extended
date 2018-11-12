import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 500 * 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        let location = CLLocationCoordinate2D(latitude: 50.064528, longitude: 19.923556)
        self.centerMapOnLocation(location: location)
        self.putAtwork(title: "Krakow", location: location)
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
