//
//  ViewController.swift
//  onTheMap
//
//  Created by Nada AlAmri on 30/04/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    
    func showAlert( title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
            return  }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: AnyObject) {
        
        
        if (usernameTextField.text!.isEmpty) || (passwordTextField.text!.isEmpty) {
            
            showAlert(title: "fill required fields", message: "Please fill username and pasword")
            
        }
            
        else {
            API.login(userEmail: usernameTextField.text!, password: passwordTextField.text!)  {(loginSuccess, key, error) in
                DispatchQueue.main.async {
                    
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                        
                        errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(errorAlert, animated: true, completion: nil)
                        return
                    }
                    
                    if !loginSuccess {
                        let loginAlert = UIAlertController(title: "Erorr logging in", message: "incorrect email or password", preferredStyle: .alert )
                        
                        loginAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(loginAlert, animated: true, completion: nil)
                    } else {
                      
                       self.performSegue(withIdentifier: "Login", sender: nil)
                        
                    }
                }}
            
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
   }
    
    
    
    
    
    
}




