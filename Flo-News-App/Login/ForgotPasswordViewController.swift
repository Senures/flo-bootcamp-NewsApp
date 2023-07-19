//
//  ForgotPasswordViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 22.06.2023.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendMailBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMailBtn.applyCornerRadius(5.0)
        
    }
    
    @IBAction func sendMail(_ sender: Any) {
        if let emailField = email.text {
            if emailField.isEmpty {
                showAlert(message: "Please enter your email")
            }
            else {
                resetPassword(email:email.text!)
            }
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func resetPassword(email:String) {
        
        showActivityIndicator()
        Auth.auth().sendPasswordReset(withEmail:email) { [self] error in
            if let error = error {
                self.hideActivityIndicator()
                print("Şifre sıfırlama e-postası gönderilirken bir hata oluştu: \(error.localizedDescription)")
                self.alertMessage(titleInput:"Error" , messageInput: error.localizedDescription ?? "Error")
                
            } else {
                
                self.hideActivityIndicator()
                let alert = UIAlertController(title: "Successful", message: "Password reset email sent", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true)
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    func alertMessage(titleInput:String ,messageInput : String ) {
        let alert = UIAlertController(title:titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
