//
//  ViewController.swift
//  MapDemo
//
//  Created by Zeitech Solutions on 24/03/17.
//  Copyright © 2017 Bansi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate ,CLLocationManagerDelegate {

    @IBOutlet weak var mapView : MKMapView!
    var geoCoder : CLGeocoder!
    var locTitle : String?
    var subTitle : String?
    var locAddress : String? = ""
    
    var locationManager : CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }

           }

    func getCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        if(self.locationManager!.location != nil){
            let location = self.locationManager!.location
            
            let latitude: Double = location!.coordinate.latitude
            let longitude: Double = location!.coordinate.longitude
            
            print("current latitude :: \(latitude)")
            print("current longitude :: \(longitude)")
            
        }
        zoomToRegion(location: mapView.centerCoordinate)
        
        

}
    func zoomToRegion(location : CLLocationCoordinate2D) {
        
     //   let location = CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        self.mapView.setRegion(region, animated: true)
         let location = self.locationManager!.location
      
        CLGeocoder().reverseGeocodeLocation(location!) { (placemarks, error) in
            if error != nil{
                print("Reverse geocoder failed with error in mapview" + (error?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! > 0 {
                let place : CLPlacemark! = placemarks?[0]
                
                if place != nil {
                    
                    self.locationManager?.stopUpdatingLocation()
                    let locality = (place.locality != nil) ? place.locality : ""
                    let postalCode = (place.postalCode != nil) ? place.postalCode : ""
                    let administrativeArea = (place.administrativeArea != nil) ? place.administrativeArea : ""
                    let country = (place.country != nil) ? place.country : ""
                    
                    print(locality!)
                    print(postalCode!)
                    print(administrativeArea!)
                    print(country!)
                    
                    let myHomePin = MKPointAnnotation()
                    myHomePin.coordinate = self.mapView.userLocation.coordinate
                    
                    myHomePin.title = country
                    
                    myHomePin.subtitle = locality
                    
                    self.mapView.addAnnotation(myHomePin)
                    
                }
                
            }else{
                print("Data Problem found")
            }
            
        }
    }

    @IBAction func zoomIn(_ sender: AnyObject) {
      
        getCurrentLocation()
          }
    
    @IBAction func changeMapType(_ sender: AnyObject) {
       
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else {
            mapView.mapType = MKMapType.standard
        }
    }
    //MARK:- map delegate
  
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if(pinView==nil){
            
            pinView=MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            
            let base = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            base.backgroundColor = UIColor.blue
            
            let label1 = UILabel(frame: CGRect(x: 30, y: 10, width: 60, height: 15))
            label1.textColor = UIColor.black
            label1.text = "text"
            base.addSubview(label1)
            pinView!.leftCalloutAccessoryView = base
         
            let btnInfo :UIButton! = UIButton(type: .detailDisclosure)
            btnInfo.addTarget(self, action: #selector(getInfo), for: .touchUpInside)
            pinView!.rightCalloutAccessoryView = btnInfo
        }
        return pinView
        
    }
    func getInfo(){
            self.performSegue(withIdentifier: "getDetail", sender: self)
        

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc : DetailVC = storyboard.instantiateViewController(withIdentifier: "getDetail") as! DetailVC
//        vc.lblAddress?.text = self.locAddress!
     //   vc.lblText = self.locAddress!
//        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
            zoomToRegion(location: mapView.centerCoordinate)
        
}
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
        
        if(self.locationManager!.location != nil){
            let location = self.locationManager!.location
            
            let latitude: Double = location!.coordinate.latitude
            let longitude: Double = location!.coordinate.longitude
            
            print("current latitude :: \(latitude)")
            print("current longitude :: \(longitude)")
            let locValue:CLLocationCoordinate2D = mapView.userLocation.coordinate
            self.zoomToRegion(location: locValue)

      CLGeocoder().geocodeAddressString(self.locAddress!) { (placemark, error) in
        if error != nil{
            print("Reverse geocoder failed with error in mapview" + (error?.localizedDescription)!)
            return
        }
        if (placemark?.count)! > 0 {
            let place : CLPlacemark! = placemark?[0]
            
            if place != nil {
                
                self.locationManager?.stopUpdatingLocation()
                let locality = (place.locality != nil) ? place.locality : ""
                let postalCode = (place.postalCode != nil) ? place.postalCode : ""
                let administrativeArea = (place.administrativeArea != nil) ? place.administrativeArea : ""
                let country = (place.country != nil) ? place.country : ""
                
                print(locality!)
                print(postalCode!)
                print(administrativeArea!)
                print(country!)
                
                let myHomePin = MKPointAnnotation()
                myHomePin.coordinate = mapView.userLocation.coordinate
                
                myHomePin.title = country
                
                myHomePin.subtitle = locality

            self.mapView.addAnnotation(myHomePin)
                
            }
            
        }else{
            print("Data Problem found")
        }

        }
            
        }
    }
 
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    
    if(self.locationManager!.location != nil){
        let location = self.locationManager!.location
        
        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude
        
        print("current latitude :: \(latitude)")
        print("current longitude :: \(longitude)")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.zoomToRegion(location: locValue)
        
    print("didUpdateLocations")
    CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
        
        if error != nil{
            print("Reverse geocoder failed with error in did update" + (error?.localizedDescription)!)
            return
        }
        if (placemarks?.count)! > 0 {
            let place : CLPlacemark! = placemarks?[0]
            
            if place != nil {
               
                self.locationManager?.stopUpdatingLocation()
                let locality = (place.locality != nil) ? place.locality : ""
                let postalCode = (place.postalCode != nil) ? place.postalCode : ""
                let administrativeArea = (place.administrativeArea != nil) ? place.administrativeArea : ""
                let country = (place.country != nil) ? place.country : ""
                
                print(locality!)
                print(postalCode!)
                print(administrativeArea!)
                print(country!)
                self.locAddress = ("\(place.locality!),\(place.postalCode!),\(place.administrativeArea!),\(place.country!)")
                
                let myHomePin = MKPointAnnotation()
                myHomePin.coordinate = manager.location!.coordinate
                
                myHomePin.title = country
                
                myHomePin.subtitle = locality
               
              self.mapView.addAnnotation(myHomePin)

            }
            
        }else{
            print("Data Problem found")
        }
    }
    }
    
}

    func locationManager(_ manager: CLLocationManager, didFailWithError: Error){
         print("didFailWithError \(didFailWithError)")
    }
        
    func locationManager(_ manager: CLLocationManager, didEnterRegion: CLRegion){
       print("didEnterRegion")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion: CLRegion){
            print("didExitRegion")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "getDetail" {

            let vc = segue.destination as! DetailVC
            
           /* if vc.lblAddress == nil {
                vc.lblAddress = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            }
            */
            vc.lblText = self.locAddress!
        }
    }
    
}
