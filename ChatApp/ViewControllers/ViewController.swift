//
//  ViewController.swift
//  ChatApp
//
//  Created by Karthikeyan on 05/03/21.
//

import UIKit
import NotificationCenter
import Firebase
import SVProgressHUD

class ViewController: UIViewController, ShowInstanceAlert {
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginOrRegisterAction(_ sender: UIButton) {
        guard let email = emailTextField.text?.trim(), let password = passwordTextField.text?.trim() else {
            let alert = UIAlertController(title: "Error", message: "Please ensure required fields are filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        switch sender.tag {
        case 0:
            registerUser(email: email, password: password)
        case 1:
            loginUser(email: email, password: password)
        default:
            return
        }
    }
    
    
    private func registerUser(email: String, password: String) {
        IJProgressView.shared.showProgressView(self.view)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                if let msg = error?.localizedDescription {
                    self.showInstantAlert(alertTitle: "Failed", alertMessage: msg)
                }
            }
            else {
                self.performSegue(withIdentifier: "toChatVC", sender: self)
                
            }
            IJProgressView.shared.hideProgressView()
        }
    }
    
    private func loginUser(email: String, password: String) {
        IJProgressView.shared.showProgressView(self.view)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                if let msg = error?.localizedDescription {
                    self.showInstantAlert(alertTitle: "Failed", alertMessage: msg)
                }
            }
            else {
                self.performSegue(withIdentifier: "toChatVC", sender: self)
            }
            IJProgressView.shared.hideProgressView()
        }
    }
}


extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
