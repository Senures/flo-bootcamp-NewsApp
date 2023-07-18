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

        isLoading.stopAnimating()
        isLoading.isHidden = true
        sendMailBtn.applyCornerRadius(5.0)
        // Do any additional setup after loading the view.
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
    
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func resetPassword(email:String) {
        print("emailllllll :\(email)")
        isLoading.startAnimating()
        isLoading.isHidden = false
        Auth.auth().sendPasswordReset(withEmail:email) { [self] error in
            if let error = error {
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
                print("Şifre sıfırlama e-postası gönderilirken bir hata oluştu: \(error.localizedDescription)")
                self.alertMessage(titleInput:"Error" , messageInput: error.localizedDescription ?? "Error")
     // Hata durumunda kullanıcıya uyarı gösterme veya ilgili işlemleri gerçekleştirme
            } else {
                
                isLoading.stopAnimating()
                isLoading.isHidden = true
                print("Şifre sıfırlama e-postası gönderildi")
                let alert = UIAlertController(title: "Successful", message: "Password reset email sent", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true) // Geri dönme işlevini çağır
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
