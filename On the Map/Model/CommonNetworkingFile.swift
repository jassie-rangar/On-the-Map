//
//  Network.swift
//  On the Map
//
//  Created by Jaskirat Singh on 11/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import Foundation
import MapKit
import UIKit
class udacityClient: UIViewController
{
    
    func studentsData(responsee: @escaping(_ error: String?)-> ())
    {
        let request = NSMutableURLRequest(url: URL(string: consturl.studenturl)!)
        request.addValue(constValue.parseAppID, forHTTPHeaderField: constkey.parseAppID)
        request.addValue(constValue.X_Parse_API, forHTTPHeaderField: constkey.X_Parse_API)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil
            {
                responsee(error?.localizedDescription)
                return
            }
            do
            {
                let parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                let jsonData = parsedResult["results"] as! [[String : Any]]
                ParseData.studentData = [Students]()
                ParseData.annotation = [MKPointAnnotation]()
                for data1 in jsonData
                {
                    let student = Students(obj: data1)
                    let annot = student.getAnnot()
                    ParseData.parseToCloud(student: student, annot)
                }
            }
            catch
            {
                print("Error: unable to parse JSON!!")
            }
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: constkey.pinAdd)))
        }
        task.resume()
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
    
    func obtainStudentLocation(completionHandler: @escaping ()-> ())
    {
        let locURL = urlRequest(apiMethod: "/StudentLocation", parameter: [parameterKeys.Where:"{\"\(parameterKeys.uniqueKey)\":\"  " + "\(ParseData.login.key)"+"\"}" as AnyObject])
        let request = NSMutableURLRequest(url: locURL)
        request.addValue(constValue.parseAppID, forHTTPHeaderField: constkey.parseAppID)
        request.addValue(constValue.X_Parse_API, forHTTPHeaderField: constkey.X_Parse_API)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {data,response,error in
            if error != nil
            {
                return
            }
            do{
                let parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                let jsonData = parsedResult["results"] as! [[String:Any]]
                if jsonData.count == 0
                {
                    DispatchQueue.main.sync
                        {
                            completionHandler()
                    }
                }
                else
                {
                    DispatchQueue.main.sync
                        {
                            ParseData.login = Students(obj: jsonData[0])
                    }
                }
            }
            catch
            {
                print("Error: Unable to obtain Student Location!")
            }
        }
        task.resume()
    }
    
    func checkLogin(email: String, password: String, responce: @escaping(_ error:String?)-> ())
    {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if(error != nil )
            {
                DispatchQueue.main.async
                    {
                        responce(error?.localizedDescription)
                }
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            (NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            do{
                let data=try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:Any]
                if (data["status"] as? Double) != nil
                {
                    DispatchQueue.main.async
                        {
                            responce("Error: Incorrect Email or Password!")
                    }
                    return
                }
                else
                {
                    let dic = data["account"] as! [String:Any]
                    ParseData.login.key = dic["key"] as! String;
                    let url=URL(string: "https://www.udacity.com/api/users/\(ParseData.login.key)")
                    var requestUrl =   URLRequest(url:  url!)
                    requestUrl.addValue(constValue.parseAppID, forHTTPHeaderField: constkey.parseAppID )
                    requestUrl.addValue(constValue.X_Parse_API , forHTTPHeaderField: constkey.X_Parse_API )
                    requestUrl.addValue("application/json", forHTTPHeaderField: "Accept")
                    requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type");
                    let session = URLSession.shared
                    let task = session.dataTask(with: requestUrl, completionHandler: { (Data, URLResponse, Error) in
                        let range = Range(5..<Data!.count)
                        let newData = Data?.subdata(in: range)
                        do{
                            let apiData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String : Any]
                            if let userData = apiData["user"] as? [String:Any] ,let firstName = userData["first_name"]  as? String , let lastName = userData["last_name"] as? String
                            {
                                ParseData.login.firstName = firstName
                                ParseData.login.lastName = lastName
                                
                                DispatchQueue.main.async
                                    {
                                        responce(nil)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async
                                    {
                                        responce("Error: Unable to Login!")
                                }
                                return
                            }
                        }
                        catch
                        {
                            DispatchQueue.main.async
                                {
                                    responce("Error: Unable to Login!")
                            }
                        }
                    })
                    task.resume()
                }
            }
            catch
            {
                print("Error: Unable to Login!")
            }
        }
        task.resume()
    }
    
    func logOut(completionHandler: @escaping(_ message: String?)-> ())
    {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")! as URL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN"
            {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie
        {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil
            {
                return
            }
        }
        task.resume()
    }
    
    func postLocation(http: String, obj: String?, resp: @escaping (_ error: String?)-> ())
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation\(obj ?? "")")!)
        request.addValue(constValue.parseAppID, forHTTPHeaderField: constkey.parseAppID)
        request.addValue(constValue.X_Parse_API, forHTTPHeaderField: constkey.X_Parse_API)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(ParseData.login.key)\", \"firstName\": \"\(ParseData.login.firstName)\", \"lastName\": \"\(ParseData.login.lastName)\",\"mapString\": \"\(ParseData.login.mapLen)\", \"mediaURL\": \"\(ParseData.login.url)\",\"latitude\": \(ParseData.login.lat) , \"longitude\":  \(ParseData.login.long)}".data(using: String.Encoding.utf8)
        request.httpMethod = http
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil
            {
                DispatchQueue.main.async
                {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                resp(error?.localizedDescription)
                return
            }
            let data = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            if obj == nil
            {
                DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
                UIApplication.shared.endIgnoringInteractionEvents()
                })
                ParseData.login.objid = data["objectId"] as! String
            }
            
            resp(nil)
        }
        task.resume()
    }

}

