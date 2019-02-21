//
//  FindLocationVC.swift
//  onTheMap
//
//  Created by Nada AlAmri on 06/05/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class FindLocationVC: UIViewController, MKMapViewDelegate{
    
    
    var long : CLLocationDegrees?
    var lat : CLLocationDegrees?
    var city : String?
    
    
    var locations: [StudentInformation] {
        return (UIApplication.shared.delegate as! AppDelegate).locationData
    }
    
    @IBOutlet weak var MapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //   guard let location = location else { return }
        
        let annotation = MKPointAnnotation()
        let coord = CLLocationCoordinate2D (latitude: lat!, longitude: long!)
        annotation.coordinate = coord
        annotation.title = city!
        
        self.MapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
         MapView.setRegion(region, animated: true)
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
    
    @IBAction func SaveBtnClicked(_ sender: Any) {
        API.getStudentInfo(){(Success, firstname, lastname,  error) in
            DispatchQueue.main.async {
                if error != nil {
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                else{
                    
          
        API.saveLocation(firstName: firstname, lastName: lastname, mapString: "", mediaURL: " ", lat: self.lat!, long: self.long!) {(Success, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                
                if Success {
                    
                    let errorAlert = UIAlertController(title: "Successfull", message: "You data has been updated", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                   
                    return
                    
                    
                }
            }
        }
        
                }
                
            }
        }
        
    }
    
    
}
