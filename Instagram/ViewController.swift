//
//  ViewController.swift
//  Instagram
//
//  Created by Abouelouafa Yassine on 11/9/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    private var signup = true
    private var x = 0
    @IBOutlet var questionOutlet: UILabel!
    @IBOutlet var singupOutlet: UIButton!
    @IBOutlet var switchOutlet: UIButton!
    @IBAction func switchSignupToLogin(_ sender: UIButton) {
        self.x += 1
        if self.x % 2 == 0 {
            self.signup = true
        }else {
            self.signup = false
        }
        if self.signup == false {
            questionOutlet.text = "Don't have an account yet ?"
            self.singupOutlet.setTitle("Log in", for: [])
            self.switchOutlet.setTitle("Sign up", for: [])
        }else{
            questionOutlet.text = "Already have an account ?"
            self.singupOutlet.setTitle("Sign up", for: [])
            self.switchOutlet.setTitle("Log in", for: [])
        }
    }
    func displayAlert(title:String,description:String) -> Void {
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func loginOrSignup(_ sender: Any) {
        if signup {
            if (self.email.text! == "" || self.password.text! == ""){
                displayAlert(title: "Error", description: "email or address not set")
            }else{
                let user = PFUser()
                user.email = email.text
                user.username = email.text
                user.password = password.text
                
                user.signUpInBackground(block: { (success, error) in
                    if let error = error {
                        self.displayAlert(title: "could not sign you up", description: error.localizedDescription)
                    } else {
                        print("you're signed up ")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
                
            }
        }
        else {
            // spinner begin
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            // spinner end
            PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
                if error != nil {
                    self.displayAlert(title: "could not log you in", description: error.debugDescription)
                }
                if user != nil {
                   self.performSegue(withIdentifier: "showUserTable", sender: self)
                    print("log in successful")
                }
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        navigationController?.navigationBar.isHidden = true
    }

}

