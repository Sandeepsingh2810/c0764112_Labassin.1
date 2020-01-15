//
//  ViewController.swift
//  c0764112_Labassin.1
//
//  Created by Sandeep Jangra on 2020-01-14.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var requiredCoordinate: CLLocationCoordinate2D!
    var pinLocation: CLLocationCoordinate2D!
    var pin : Int = 0
    var distance = [Double]()

    
    @IBOutlet weak var zoonStepper: UIStepper!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var typesOfTransport: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       zoonStepper.value = 0
       zoonStepper.minimumValue = -5
       zoonStepper.maximumValue = 5
        mapView.delegate = self as? MKMapViewDelegate
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyBest
              locationManager.requestWhenInUseAuthorization()
              locationManager.startUpdatingLocation()
        mapView.showsUserLocation=true
        
    adddoubleTap()
             
    }
    
    @IBAction func transportType(_ sender: Any) {
    }
    
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
     
     {
           let userLocation : CLLocation = locations[0]
        
           let latitude = userLocation.coordinate.latitude
        
           let longitude = userLocation.coordinate.longitude
        
           let latDelta : CLLocationDegrees = 0.05
        
           let lonDelta : CLLocationDegrees = 0.05
           let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
           let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
           let region = MKCoordinateRegion(center: location, span: span)
           mapView.setRegion(region, animated: true)

       }
  
    @IBAction func navBtn(_ sender: Any) {
   
        direction(sourcePlaceMark: MKPlacemark(coordinate: locationManager.location!.coordinate), destinationPlacMark: MKPlacemark(coordinate: pinLocation))
              
             
        
    }
    
    
    func direction(sourcePlaceMark: MKPlacemark , destinationPlacMark: MKPlacemark){
             
           let request = MKDirections.Request()
                   request.source = MKMapItem(placemark: sourcePlaceMark)
                   request.destination = MKMapItem(placemark: destinationPlacMark)
                 
              if typesOfTransport.selectedSegmentIndex == 0
                
              {
                  request.transportType = .walking
                }
                
                else if
                typesOfTransport.selectedSegmentIndex == 1
              
              {
              
                  request.transportType = .automobile

               
                
                }
        
        
             let directions = MKDirections(request: request)
             directions.calculate { [unowned self] response, error in
               guard let unwrappedResponse = response else
               
               { return
                
                }
                     for route in unwrappedResponse.routes {
                     self.mapView.addOverlay(route.polyline)
         }
}

}
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
      let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
         renderer.lineWidth = 3
          if typesOfTransport.selectedSegmentIndex == 0
          {
               renderer.strokeColor = UIColor.orange
              
        }  else if
            typesOfTransport.selectedSegmentIndex == 1
          {
                    
           renderer.strokeColor = UIColor.blue
        }
        
      return renderer
        
        
    }
    
    func zoomMap(byFactor delta: Double) {
     var region: MKCoordinateRegion = self.mapView.region
     var span: MKCoordinateSpan = mapView.region.span
     span.latitudeDelta *= delta
     span.longitudeDelta *= delta
     region.span = span
     mapView.setRegion(region, animated: true)
    }
    
    
    
    
    @IBAction func zoomStepperPressed(_ sender: UIStepper)
        
        
    {
        
        if sender.value < 0
            
            
         {
            
          var region: MKCoordinateRegion = mapView.region
          region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
          region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
          mapView.setRegion(region, animated: true)
          zoonStepper.value = 0
            
         }
            
         else
            
         {
            
          var region: MKCoordinateRegion = mapView.region
          region.span.latitudeDelta /= 2.0
          region.span.longitudeDelta /= 2.0
          mapView.setRegion(region, animated: true)
          zoonStepper.value = 0
            
         }
        }
    }
    

    
    extension ViewController : UIGestureRecognizerDelegate, MKMapViewDelegate {
    
        
        func adddoubleTap() {
      let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
      doubleTap.numberOfTapsRequired = 2
      doubleTap.delegate = self
      mapView.addGestureRecognizer(doubleTap)
        }
        
        
        
    @objc func dropPin(sender: UITapGestureRecognizer) {
      pin = pin + 1
      mapView.removeOverlays(mapView.overlays)
      let touchPoint = sender.location(in: mapView)
      
      let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
      let annotation = Pin(coordinate: coordinate, identifier: "pin")
      mapView.addAnnotation(annotation)
      pinLocation = coordinate
     
    if (pin==2)
    { pin = 0
      deletePin()
    }
    else
    {
       
    }
      requiredCoordinate = coordinate
      
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if annotation is MKUserLocation {
        
        
        return nil
        }
        
      let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
      pinAnnotation.animatesDrop = true
      return pinAnnotation
      
    }
    
    func deletePin() {
    for annotation in mapView.annotations {
      mapView.removeAnnotation(annotation)
        }
      
    }
    
}
