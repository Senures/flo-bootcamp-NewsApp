//
//  RegisterScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 23.06.2023.
//

import UIKit
import FirebaseFirestore
import Firebase


protocol RegisterScreenControllerProtocol : AnyObject {
    func setupUI()
    func validateTextFields()
    func succesfulRegisterAlert()
}
class RegisterScreenViewController: UIViewController , RegisterScreenControllerProtocol {
    
    let viewModel = RegisterScreenViewModel()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        //view modelın delegate
        viewModel.viewDidLoad()
    }
    
    func setupUI() {
        numberField.delegate = self
        passwordField.delegate = self
        emailField.autocorrectionType = .no
        nameField.autocorrectionType = .no
        numberField.autocorrectionType = .no
        passwordField.autocorrectionType = .no
        registerBtn.applyCornerRadius(5.0)
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        validateTextFields()
    }
    
    func validateTextFields() {
        // Email kontrolü
        if let email = emailField.text {
            if email.count < 8 || !email.contains("@") || !email.contains(".com") {
                // Geçersiz e-posta adresi
                AlertUtils.showAlert(from: self, withMessage: "Enter a valid email address!")

                return
            }
        } else {
            // Email alanı boş
            AlertUtils.showAlert(from: self, withMessage:"Email field cannot be empty!")
            
            return
        }
        
        // Name kontrolü
        if nameField.text?.isEmpty ?? true {
            
            AlertUtils.showAlert(from: self, withMessage:"Please enter name")
        }
        
        // Telefon kontrolü
        if let phone = numberField.text {
            if phone.count < 10 {
                // Telefon alanı 10 karakterden az
                AlertUtils.showAlert(from: self, withMessage:"Phone field must be at least 10 characters!")
                
                return
            }
        } else {
            // Telefon alanı boş
            AlertUtils.showAlert(from: self, withMessage:"Phone field cannot be empty!")
           
            return
        }
        
        // Şifre kontrolü
        if let password = passwordField.text {
            if password.count < 10  {
             
                AlertUtils.showAlert(from: self, withMessage:"Password field must be at least 10 characters!")
               
                return
            }
        } else {
            // Şifre alanı boş
            AlertUtils.showAlert(from: self, withMessage:"Password field cannot be empty!")
            
            return
        }
        
        // Tüm alanlar geçerli, kaydetme işlemi yapılabilir
        showActivityIndicator()
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { [self] (authResult, error) in
            if error != nil {
                self.hideActivityIndicator()
                AlertUtils.showCustomAlert(from: self, title: "Error", message: error?.localizedDescription ?? "Error")
            
            } else{
                viewModel.saveUserToFirestore(username: nameField.text! , email: emailField.text!, password: passwordField.text!, phoneNumber: numberField.text!)
                self.hideActivityIndicator()
                
            }
            
        }
        
    }
    //MARK:kaydetme işlem basarılı oldugunda login sayfasına yönlendirir
    func succesfulRegisterAlert(){
        let alert = UIAlertController(title: "Successful", message: "User information has been saved, you can log in.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (_) in
            self.performSegue(withIdentifier: "goLogin", sender: nil)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: telefon ve password alanına karakter sınırlaması getirmek
extension RegisterScreenViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                guard let currentText = textField.text,
                      let range = Range(range, in: currentText) else {
                    return true
                }

                let updatedText = currentText.replacingCharacters(in: range, with: string)
                return updatedText.count <= 10
    }
    
}

