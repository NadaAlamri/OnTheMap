//
//  LocationsTableVC.swift
//  onTheMap
//
//  Created by Nada AlAmri on 03/05/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//



import Foundation
import UIKit

class LocationsTableVC: UITableViewController {
    
    var locations: [StudentInformation] {
        return (UIApplication.shared.delegate as! AppDelegate).locationData
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //make Sure the tab bar is present and navigation bar are present
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        print(locations)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        // print(locations)
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
    
    //get the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    
    //populate the cell
    override func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentCell
        let student = locations[indexPath.row]
        
        cell.StudentLbl.text = "Name: \(student.firstName ?? " ") \(student.lastName ?? "") \r\n URL: \(student.mediaURL ?? "") "
        cell.StudentPin.image = #imageLiteral(resourceName: "icon_pin")
        return cell
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = URL(string: self.locations[(indexPath as NSIndexPath).row].mediaURL!) else {
            let errorAlert = UIAlertController(title: "Error", message: "Can't open the provided URL", preferredStyle: .alert )
            
            errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
        
    }
    
    
}
