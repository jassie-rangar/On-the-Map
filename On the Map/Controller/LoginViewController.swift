//
//  LoginViewController.swift
//  On the Map
//
//  Created by Jaskirat Singh on 06/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit

class LoginViewController: udacityClient, UITextFieldDelegate
{
    
    //MARK: IBOutlets
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var activity_processor: UIActivityIndicatorView!
    
    //MARK: Setting the DataTypes
    var getEmail : CGFloat!
    var getPassword : CGFloat!
    var butn : CGFloat!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DispatchQueue.main.async
        {
            self.activity_processor.isHidden = true
            self.initialSetup()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        DispatchQueue.main.async
        {
                self.activity_processor.isHidden = true
        }
}
    
    func initialSetup()
    {
        getEmail = email.center.x
        getPassword = password.center.x
        butn = login.center.x
        email.delegate = self
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return true
    }
    
    
    @IBAction func login(_ sender: Any)
    {
        if email.text == "" || password.text == ""
        {
            alert(message: "Please enter the valid credentials!!")
        }
        else
        {
            setUI(enable: false)
            checkLogin(email: email.text!, password: password.text!, responce: responceOnLogin(e:))
            self.activity_processor.isHidden = false
            email.text = ""
            password.text = ""
        }
    }
    
    func responceOnLogin(e error: String?)
    {
        if error != nil
        {
            loginFail()
            alert(message: error!)
            self.activity_processor.isHidden = true
        }
        else
        {
            DispatchQueue.main.async
            {
                self.setUI(enable: true)
                self.loginComplete()
                self.activity_processor.isHidden = false
            }
        }
    }
    
    func loginComplete()
    {
        setUI(enable: true)
        let control = storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! UITabBarController
        present(control, animated: true, completion: nil);
    }
    
    func loginFail()
    {
        self.setUI(enable: true)
    }
    
    func setUI(enable: Bool)
    {
        self.email.isEnabled = enable
        self.password.isEnabled = enable
        self.login.isEnabled = enable
        if !enable
        {
            self.view.alpha = 0.7
        }
        else
        {
            self.view.alpha = 1
        }
    }
}
    
private extension LoginViewController
{
    func alert(message: String)
    {
        DispatchQueue.main.async
        {
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                action in
                DispatchQueue.main.async
                {
                    self.setUI(enable: true)
                }
                }))
            self.present(alertView, animated: true, completion: nil)
        }
    }
}
