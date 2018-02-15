//
//  ParseData.swift
//  On the Map
//
//  Created by Jaskirat Singh on 10/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import Foundation
import MapKit
struct ParseData
{
    static var studentData = [Students]()
    static var annotation = [MKPointAnnotation]()
    static var login = Students()
    static var location: String = ""
    static var annot: MKPointAnnotation?
    static var reg: MKCoordinateRegion?
    
    
    static func parseToCloud(student: Students,_ annot: MKPointAnnotation?)
    {
        studentData.append(student)
        if annot != nil
        {
            annotation.append(annot!)
        }
    }
    
    func urlRequest(apiMethod: String?, parameter:[String : AnyObject]? = nil) -> URL
    {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "parse.udacity.com"
        comp.path = "/parse/classes"
         + (apiMethod ?? "")
        
        if let parameter = parameter
        {
            comp.queryItems = [URLQueryItem]()
            for(key, value) in parameter
            {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                comp.queryItems?.append(queryItem)
            }
        }
        return comp.url!
    }
}
