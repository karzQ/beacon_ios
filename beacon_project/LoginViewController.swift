//
//  LoginViewController.swift
//  beacon_project
//
//  Created by Quentin Karczinski on 26/04/2018.
//  Copyright © 2018 Quentin Karczinski. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var buttonConnectToApp: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var stayConnectedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        stayConnectedSwitch.isOn = (appDelegate?.stayConnected)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validateFormular(_ sender: Any) {
        /* let json =
        let session = URLSession.shared
        let u = URL(string: "/api/")
        var request = URLRequest(url: u!)
        
        request.httpMethod = "POST"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "{\"hello\" : \"hello\"}".data(using: .utf8)*/
        
        if(usernameField.text == "root" && pwdField.text == "root"){
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.username = usernameField.text!
            
            //UserDefaults.
            
            if let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "listAlertView") as? ViewController{
                    self.navigationController?.pushViewController(nextPage, animated: true)
            }
        }
    }
    
    @IBAction func stayConnectedOnClick(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.stayConnected = stayConnectedSwitch.isOn
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
