//
//  AddLocationVC.swift
//  onTheMap
//
//  Created by Nada AlAmri on 05/05/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class AddLocationVC: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var studentUrlTxtField: UITextField!
    @IBOutlet weak var locationNameTxtField: UITextField!
     let activityIndicator =    UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var long : CLLocationDegrees = 0.0
    var lat : CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func showAlert( title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
            return  }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func AddLocationBtn(_ sender: Any) {
       
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
    //    ActivityIndicator(_on: true)
        
        if (studentUrlTxtField.text!.isEmpty) || (locationNameTxtField.text!.isEmpty) {
            
            showAlert(title: "fill required fields", message: "Please fill city and url")
            return
        }
      
   
        CLGeocoder().geocodeAddressString(locationNameTxtField.text!) { (placeMarks, err) in
            guard let firstLocation = placeMarks?.first?.location else {
                self.showAlert(title: "Error", message: "Specified Location was not recognized")
                return }
            self.long = firstLocation.coordinate.longitude
            self.lat = firstLocation.coordinate.latitude
            
         // self.ActivityIndicator(_on: false)
            
            
          activityIndicator.removeFromSuperview()
        self.performSegue(withIdentifier: "location", sender: sender)
    }
    }
    
  
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            
              if segue.identifier == "location", let vc = segue.destination as?  FindLocationVC
            { vc.long = long
                vc.lat = lat
                vc.city = locationNameTxtField.text
                 navigationController?.isNavigationBarHidden = false
                
            }
            
  
        }
    
        
        
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
