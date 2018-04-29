//
//  LoginViewController.swift
//  beacon_project
//
//  Created by Quentin Karczinski on 26/04/2018.
//  Copyright © 2018 Quentin Karczinski. All rights reserved.
//

import UIKit
import CryptoSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var buttonConnectToApp: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var stayConnectedSwitch: UISwitch!
    @IBOutlet weak var buttonTestData: UIButton!
    
    @IBOutlet weak var loginSubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashing()
        
        self.view.addSubview(loginSubView)
        
        let defaults = UserDefaults.standard
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if (defaults.bool(forKey: "stayConnected") == true){
            if((defaults.value(forKey: "username")) != nil){
                loginSubView.isHidden = true
                if let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "listAlertView") as? ViewController{
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }
            }
        }
        
        stayConnectedSwitch.isOn = (appDelegate?.stayConnected)!
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loginSubView.isHidden = false
        usernameField.text = UserDefaults.standard.string(forKey: "username")
        pwdField.text = UserDefaults.standard.string(forKey: "password")
        stayConnectedSwitch.isOn = UserDefaults.standard.bool(forKey: "stayConnected")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validateFormular(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let path = Bundle.main.path(forResource: "testFile", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        do{
            let data = try? Data(contentsOf: url)
            let login = try? JSONDecoder().decode([String:String].self, from: data!)
            
            if(usernameField.text == login!["Email"]! && pwdField.text == login!["Password"]!){
                if(defaults.string(forKey: "username") == nil){
                    defaults.set(usernameField.text, forKey: "username")
                    defaults.set(pwdField.text, forKey: "password")
                    defaults.set(stayConnectedSwitch.isOn, forKey: "stayConnected")
                    
                } else if(defaults.string(forKey: "Email") != login!["Email"]!){
                    defaults.set(login!["Email"]!, forKey: "username")
                    defaults.set(login!["Password"]!, forKey: "password")
                    defaults.set(stayConnectedSwitch.isOn, forKey: "stayConnected")
                }
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.username = usernameField.text!
                
                if let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "listAlertView") as? ViewController{
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Wrong identifiers", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        } catch {}
    }
    
    @IBAction func stayConnectedOnClick(_ sender: UISwitch) {
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        UserDefaults.standard.set(stayConnectedSwitch.isOn, forKey: "stayConnected")
    }
    
    @IBAction func testData(_ sender: Any) {
        //let session = URLSession.shared
        /*let u = URL(string: "https://d1a32b63.ngrok.io/api/login")
        var request = URLRequest(url: u!)
    
        request.httpMethod = "POST"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "{\"hello\" : \"hello\"}".data(using: .utf8)*/
        
        /*let session = URLSession.shared
        let u = URL(string: "https://d1a32b63.ngrok.io/api/login")
        var request = URLRequest(url: u!)
        
        request.httpMethod = "POST"*/
        
        // Trouvé à : https://stackoverflow.com/questions/48720925/swift-4-send-post-request-as-x-www-form-urlencoded?noredirect=1&lq=1
        /*request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        let pwd = pwdField.text
        let login = usernameField.text
        
        request.httpBody = "email=\(usernameField.text ?? "")&password=\(pwdField.text ?? "")".data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, res, err) in
            if let d = data {
                print(String(data: d, encoding: .utf8) as Any)
                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:Any] {
                    let dataOut = try? JSONSerialization.data(withJSONObject: o, options: .prettyPrinted)
                    
                    print(o)
                    print(dataOut as Any)
                }
                
                print(data as Any)
            }
        }
        
        print(task.debugDescription)
        print(task.description)
        print(task.resume())
        task.resume()*/
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let session = URLSession.shared
        let u = URL(string: "https://d1a32b63.ngrok.io/api/login")
        var request = URLRequest(url: u!)
        request.httpMethod = "POST"
        request.setValue("Allow-Compression", forHTTPHeaderField: "true")
        request.httpBody = "email=\(usernameField.text ?? "")&password=\(pwdField.text ?? "")".data(using: .utf8)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let d = data {
                if let o = (try? JSONSerialization.jsonObject(with: d, options: [])) as? [String:String] {
                    
                    UserDefaults.standard.set(true, forKey: o["token"]!)
                    
                    if let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "listAlertView") as? ViewController{
                        self.navigationController?.pushViewController(nextPage, animated: true)
                    }
                } else {
                    return
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Wrong identifiers", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
        
        task.resume()
    }
    
    func hashing() {
        let hash = "password".sha512();
        print("password hashé : " + hash)
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
