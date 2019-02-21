//
//  LocationMapVC.swift
//  onTheMap
//
//  Created by Nada AlAmri on 02/05/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//

import Foundation
import MapKit
import UIKit
class LocationMapVC: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var MapView: MKMapView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        API.getLocations () {(studentsLocations, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                var annotations = [MKPointAnnotation] ()
                
                guard let locationsArray = studentsLocations else {
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                }
                
                //Loop through the array of structs and get locations data from it so they can be displayed on the map
                for studentItem in locationsArray {
                    
                    let long = CLLocationDegrees (studentItem.longitude ?? 0)
                    let lat = CLLocationDegrees (studentItem.latitude ?? 0)
                    
                 
                    
                    
                    let mediaURL = studentItem.mediaURL ?? " "
                    
                  
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D (latitude: lat, longitude: long)
                    annotation.title = "\(studentItem.firstName ?? " ") \(studentItem.lastName ?? "")"
                    annotation.subtitle = mediaURL
                    
                    annotations.append (annotation)
                    
                    //==========
                    let object = UIApplication.shared.delegate as! AppDelegate
                    object.locationData.append(studentItem)
                    
                   
                }
                self.MapView.addAnnotations (annotations)
            }
            
        }//end getAllLocations
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin!.canShowCallout = true
         //   pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func addLocationBtn(_ sender: Any) {
        let control = storyboard!.instantiateViewController(withIdentifier: "addLocation")
       // navigationController?.isNavigationBarHidden = true
       tabBarController?.tabBar.isHidden = true
        
        navigationController!.pushViewController(control, animated: true)
        
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        API.deleteSession()
        let control = storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        navigationController!.pushViewController(control, animated: true)
        
    }
}
