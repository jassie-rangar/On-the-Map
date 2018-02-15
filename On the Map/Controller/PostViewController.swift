//
//  PostViewController.swift
//  On the Map
//
//  Created by Jaskirat Singh on 11/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: udacityClient, UITextFieldDelegate
{

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var linkurl: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submit: UIBarButtonItem!
   
    
    var update: Bool!
    let ai = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        location.delegate = self
        linkurl.delegate = self
        submit.isEnabled = false
        linkurl.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return true
    }
    
    @IBAction func findLocation(_ sender: Any)
    {
        view.endEditing(true)
        if location.text == ""
        {
            alert(message: "Please enter the valid Location!!", tryAgain: false, resp: {})
            return
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        ai.activityIndicatorViewStyle = .gray
        ai.hidesWhenStopped = true
        ai.center = self.view.center
        ai.startAnimating()
        self.view.addSubview(ai)
        
        let searchLoc = MKLocalSearchRequest()
        searchLoc.naturalLanguageQuery = location.text
        
        let search = MKLocalSearch(request: searchLoc)
        UIApplication.shared.endIgnoringInteractionEvents()
        search.start{ (MKLocalSearchResponse, Error ) in
            if MKLocalSearchResponse == nil
            {
                self.ai.stopAnimating()
                self.alert(message: "No Internet Connection or invalid Location!!", tryAgain: true, resp: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else
            {
                let coord = MKLocalSearchResponse?.boundingRegion.center
                let annot = MKPointAnnotation()
                annot.coordinate = coord!
                ParseData.login.lat = (coord?.latitude) ?? 0.0
                ParseData.login.long = (coord?.longitude) ?? 0.0
                annot.title = self.location.text
                
                self.ai.stopAnimating()
                self.UI(enable: true)
                
                self.mapView.addAnnotation(annot)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coord!, span: span)
                self.mapView.setRegion(region, animated: true)
                self.submit.isEnabled = true
                self.linkurl.isEnabled = true
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: Any)
    {
        ParseData.login.url = location.text!
        
        if linkurl.text == ""
        {
            self.alert(message: "Please enter the valid Link", tryAgain: false, resp: {})
            return
        }
        ai.startAnimating()
        ParseData.login.url = linkurl.text!
        
        if update == nil
        {
            postLocation(http: "POST", obj: nil, resp: response(e: ))
        }
        else
        {
            postLocation(http: "PUT", obj: "\(ParseData.login.objid)", resp: response(e: ))
        }
    }
    
    func response(e error: String?)
    {
        if error == nil
        {
            DispatchQueue.main.async
            {
                self.ai.stopAnimating()
            }
        }
        else
        {
            DispatchQueue.main.async
            {
                self.alert(message: error!, tryAgain: true, resp: {
                    self.dismiss(animated: true, completion: nil)
                } )
                self.ai.stopAnimating()
            }
        }
    }
    
    func alert(message: String, tryAgain: Bool, resp: @escaping (()-> ()))
    {
        DispatchQueue.main.async
        {
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Dissmiss", style: .default, handler: {
                a in
                resp()
            }))
            
            if tryAgain
            {
                alertView.addAction(UIAlertAction(title: "Please Try Again!!", style: .default, handler: { (UIAlertAction) in
                    self.UI(enable: false)
                }))
            }
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func UI(enable: Bool)
    {
        DispatchQueue.main.async
        {
            self.findLocation.isHidden = enable
            self.location.isHidden = enable
        }
    }
 
}
