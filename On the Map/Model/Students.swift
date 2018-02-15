//
//  Students.swift
//  On the Map
//
//  Created by Jaskirat Singh on 10/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import Foundation
import MapKit

struct Students
{
    var firstName = ""
    var long: Double = 0.0
    var lat: Double = 0.0
    var url = ""
    var key = ""
    var objid = ""
    var lastName = ""
    var mapLen = ""
    var link = ""
    var fullName: String
    {
        return "\(firstName) \("") \(lastName)"
    }
    
    init()
    {
    }
    
    init(key: String, name: String)
    {
    }
    
    init(obj:[String: Any])
    {
        self.firstName = "\(obj["firstName"] ?? "")"
        self.long = obj["longitude"] as? Double ?? 0
        self.lat = obj["latitude"] as? Double ?? 0
        self.url = "\(obj["mediaURL"] ?? "")"
        self.objid = "\(obj["objectID"] ?? "")"
        self.mapLen = "\(obj["mapString"] ?? "")"
        self.link = "\(obj["mediaURL"] ?? "")"
        self.lastName = "\(obj["lastName"] ?? "")"
    }
    
    func getAnnot()->MKPointAnnotation
    {
        let annot = MKPointAnnotation()
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annot.coordinate = coord
        annot.title = self.fullName
        annot.subtitle = self.url
        return annot
    }
}
