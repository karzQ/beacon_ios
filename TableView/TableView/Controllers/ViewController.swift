//
//  ViewController.swift
//  TableView
//
//  Created by Christopher Loubassou on 27/04/2018.
//  Copyright © 2018 Christopher Loubassou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...1000 {
            data.append("\(i)")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private var data: [String] = []

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // Differenct color 1 on 2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! CustomTableViewCell
        
        let text = data[indexPath.row]
        
        cell.label.text = text
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.blue
        } else {
            cell.contentView.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
    // Alert when you tap on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }


}

