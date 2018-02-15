//
//  TableViewController.swift
//  On the Map
//
//  Created by Jaskirat Singh on 11/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit

class TableViewController:Roots, UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        notifi()
        studentsData(responsee: {
            error in
            if error != nil
            {
                self.alert(message: error!)
            }
        })
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ParseData.studentData.count
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chamber") as! TableViewCell
        cell.configCell(student1: ParseData.studentData[indexPath.row])
        return cell
    }

    @objc func reload()
    {
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }
    
    func notifi()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: constkey.pinAdd), object: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url = ParseData.studentData[indexPath.row].link
        if let url = NSURL(string: url)
        {
            if UIApplication.shared.canOpenURL(url as URL)
            {
                UIApplication.shared.open(url as URL)
            }
            else
            {
                alert(message: "Unable to open URL!")
            }
        }
    }
}
