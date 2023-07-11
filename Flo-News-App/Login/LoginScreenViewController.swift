//
//  LoginScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 20.06.2023.
//

import UIKit
import Firebase

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var forgotPasBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var showPassBtn: UIButton!
    @IBOutlet weak var signApple: UIView!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    var isShowPassword : Bool = false
    let closeEye = UIImage(named: "close")
    
    //let iconImageView = UIImageView(image:UIImage(named: <#T##String#>))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.textColor = .black
        passwordField.textColor = .black
        loginBtn.layer.cornerRadius = 5
        signApple.layer.cornerRadius = 5
        passwordField.isSecureTextEntry = true
        
        isLoading.stopAnimating()
        isLoading.isHidden = true
        
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        validateTextFields()
    }
    @IBAction func goRegisterPage(_ sender: Any) {
        performSegue(withIdentifier:"goRegister", sender: nil)
        print("butonaaa tıklandıııı")
    }
    @IBAction func forgotPassClick(_ sender: Any) {
        performSegue(withIdentifier: "resetPassword", sender:nil)
    }
    // şifre gösterilmesi
    @IBAction func showPassBtn(_ sender: Any) {
        print("basıldııııııııııı")
        isShowPassword = !isShowPassword
        print("\(isShowPassword)")
        if isShowPassword {
            passwordField.isSecureTextEntry = false
            showPassBtn.setImage(closeEye, for: .normal)
            
        } else {
            passwordField.isSecureTextEntry = true
            showPassBtn.setImage(UIImage(named: "eye"), for: .normal)
            
        }
        
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(titleInput:String ,messageInput : String ) {
        let alert = UIAlertController(title:titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true)
    }
    
    func validateTextFields(){
        // email alanını kontrol ediyor boş  girmesin diye
        if let email = emailField.text {
            if email.isEmpty {
                showAlert(message: "Lütfen email  gir")
            }
        }
        
        if let password = passwordField.text {
            if password.isEmpty {
                showAlert(message: "Lütfen password  gir")
            }
        }
        self.isLoading.isHidden = false
        self.isLoading.startAnimating()
        Auth.auth().signIn(withEmail:emailField.text!, password: passwordField.text!) { (authResult, error) in
            // Hesap oluşturulduğunda veya bir hata olduysa yapılacak işlemler burada gerçekleştirilir.
           
            if error != nil {
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
                self.alertMessage(titleInput:"Error" , messageInput: error?.localizedDescription ?? "Error")
            } else{
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
                print("kullanıcı oluşturulduuu")
                self.performSegue(withIdentifier:"goHome", sender: nil)
                
            }
            
        }
        
        
        
    }
    
}
