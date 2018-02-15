//
//  Root.swift
//  On the Map
//
//  Created by Jaskirat Singh on 10/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit

class Roots: udacityClient
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func getData(response: @escaping(_ error: String?)-> ())
    {
        studentsData(responsee:{
            error in
            response(error)
        })
    }
    
    func postVCont()
    {
        if ParseData.login.objid != ""
        {
            DispatchQueue.main.async
            {
                self.alert(message: "Do you want to overwrite the location?", completionHandler: {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "post") as! PostViewController
                    self.present(controller, animated: true, completion: nil)
                })
            }
        }
        else
        {
            postVC()
        }
    }
    
    private func postVC()
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "post") as! PostViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func alert(message: String, completionHandler: @escaping()-> ())
    {
        DispatchQueue.main.async
        {
            let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Add New Pin Location!!", style: .default, handler: {
                action in
                self.postVC()
            }))
            
            alertview.addAction(UIAlertAction(title: "Overwrite previous Pin Location!!", style: .default, handler: {
                action in
                completionHandler()
            }))
            self.present(alertview, animated: true, completion: nil)
        }
    }
    
    func logOut()
    {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        dismiss(animated: true, completion: nil)
    }
    
}
