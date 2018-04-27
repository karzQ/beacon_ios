//
//  ViewController.swift
//  beacon_project
//
//  Created by Quentin Karczinski on 26/04/2018.
//  Copyright © 2018 Quentin Karczinski. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    
    let manager = CLLocationManager()
    
    /*
     Application permettant de se connecter afin de gérer le fait d'être dans une région d'un beacon actif.
     Lorsque l'on passe dedans, que l'on en sort, notifications à afficher.
     Si l'on est dans la cours, on est toujours dans la région.
     MAIS si l'on est dans la salle de cours, on a un QR-Code à envoyer au serveur pour attester de notre présence.
     
     UI : Pas de demande particulière
     
     HTTP : Récupérer les données venant d'une API à l'aide des routes données
     POST /api/login
     POST /api/refreshToken
     GET /api/getLocation (salle prévue)
     POST /api/checkIn
     POST /getQRCode
     
     Beacon : On ne peut pas tester de manière réelle.
     
     QR-Code : afficher un QR-Code à envoyer au serveur
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        helloLabel.text = "Bonjour \(appDelegate?.username ?? "Name")."
        
        let layerScanButton = scanButton.layer
        layerScanButton.cornerRadius = 5
        
        
        
        //Heading = directio,
        //CLRegion différence entre les zones où l'on est ou pas => zone géographique
        //on veut savoir quand on va dedans, qu'on va dehors et que l'on passe la frontière
        //RangingBeacon
        //startMonitorinhSignificantLocationChanges => alert lors d'un changement de position conséquent (1m au lieu de tous les cm)
        
        //peut servir à communiquer avec le serveur si jamais il y a un problème rencontré
        manager.delegate = self
        
        if(CLLocationManager.authorizationStatus() != .authorizedWhenInUse){
            // Demande à l'utilisateur si l'on peut utiliser sa geolocalisation
            manager.requestWhenInUseAuthorization()
        } else {
            startRanging()
        }
        
    }
    
    fileprivate func startRanging(){
        // grand nombre dont la moitié est le major et l'autre le minor
        let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "F2A74FC4-7625-44DB-9B08-CB7E130B2029")!, major: 65535, minor: 382, identifier: "premier")
        manager.startRangingBeacons(in: beaconRegion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse){
            startRanging()
        }
    }
    
    // automatiquement exectuée par le manager lorsqu'il trouve un beacon
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //Lorsque l'on est dans la region d'un beacon, affiche l'id de la region du beacon en question
        print(region.identifier)
        
        //Pour chaque beacon dont on est dans leur region, on affiche leur minor
        for b in beacons{
            //b.accuracy => distance entre le beacon et l'appareil
            print(b.accuracy)
        }
    }
    
    @IBAction func scannQRCodeAction(_ sender: Any) {
        if let scanCodePage = self.storyboard?.instantiateViewController(withIdentifier: "scanQRCodeView") as? QRCodeViewController{
            self.navigationController?.pushViewController(scanCodePage, animated: true)
        }
    }
    
}

