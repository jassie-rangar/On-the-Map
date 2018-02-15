//
//  MapViewController.swift
//  On the Map
//
//  Created by Jaskirat Singh on 11/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapViewController: Roots, MKMapViewDelegate
{

    @IBOutlet weak var map: MKMapView!
    
    var addpin = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        notifi()
        studentsData(responsee: {
            error in
            if error != nil
            {
                self.alert(message: error!)
            }
        })
    }
    
    @IBAction func refreshData(_ sender: Any)
    {
        super.getData(response: {
            error in
            if error != nil
            {
                self.alert(message: error!)
            }
        })
    }
    
    @IBAction func addPin(_ sender: Any)
    {
        super.postVCont()
    }
    
    @IBAction func logout(_ sender: Any)
    {
        super.logOut()
    }
    
    
    @objc func addPins()
    {
        if !ParseData.annotation.isEmpty
        {
            DispatchQueue.main.async
            {
                self.addpin = ParseData.annotation
                self.map.removeAnnotations(self.map.annotations)
                self.map.addAnnotations(self.addpin)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?
    {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .purple
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func notifi()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(addPins), name: NSNotification.Name(rawValue: constkey.pinAdd), object: nil)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            let url: NSString = (view.annotation?.subtitle)!! as NSString
            let urlStr: NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            if let URL = NSURL(string: urlStr as String)
            {
                if UIApplication.shared.canOpenURL(URL as URL)
                {
                    UIApplication.shared.open(URL as URL)
                }
                else
                {
                    alert(message: "Unable to open URl!")
                }
            }
        }
    }
    
    func alert(message: String)
    {
        DispatchQueue.main.async
            {
                let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: {
                    a in
                }))
                self.present(alertView,animated: true, completion: nil)
        }
    }

}
