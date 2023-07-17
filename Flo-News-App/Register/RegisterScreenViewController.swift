//
//  RegisterScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 23.06.2023.
//

import UIKit
import FirebaseFirestore
import Firebase

class RegisterScreenViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberField.delegate = self
        emailField.autocorrectionType = .no
        nameField.autocorrectionType = .no
        numberField.autocorrectionType = .no
        passwordField.autocorrectionType = .no
        // Do any additional setup after loading the view.
        
        registerBtn.layer.cornerRadius = 5
        
       indicator.stopAnimating()
       indicator.isHidden = true
    }
    
    
    @IBAction func registerBtnClick(_ sender: Any) {
        validateTextFields()
    }
    
    private func validateTextFields() {
        // Email kontrolü
        if let email = emailField.text {
            if email.count < 8 || !email.contains("@") || !email.contains(".com") {
                // Geçersiz e-posta adresi
                showAlert(message: "Enter a valid email address!")
                return
            }
        } else {
            // Email alanı boş
            showAlert(message: "Email field cannot be empty!")
            return
        }
        
        // Name kontrolü
        if nameField.text?.isEmpty ?? true {
                showAlert(message: "Please enter name")
            
        }
        
        // Telefon kontrolü
        if let phone = numberField.text {
            if phone.count < 10 {
                // Telefon alanı 8 karakterden az
                showAlert(message: "Phone field must be at least 10 characters!")
                return
            }
        } else {
            // Telefon alanı boş
            showAlert(message: "Phone field cannot be empty!")
            return
        }
        
        // Şifre kontrolü
        if let password = passwordField.text {
            if password.count < 9 {
                // Şifre alanı 8 karakterden az
                showAlert(message: "Password field must be at least 8 characters!")
                return
            }
        } else {
            // Şifre alanı boş
            showAlert(message: "Password field cannot be empty!")
            return
        }
        
        // Tüm alanlar geçerli, kaydetme işlemi yapılabilir
        indicator.startAnimating()
        indicator.isHidden = false
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { [self] (authResult, error) in
            // Hesap oluşturulduğunda veya bir hata olduysa yapılacak işlemler burada gerçekleştirilir.

            if error != nil {
                indicator.stopAnimating()
                indicator.isHidden = true
                self.alertMessage(titleInput:"Error" , messageInput: error?.localizedDescription ?? "Error")
            } else{
             
                self.saveUserToFirestore(username: nameField.text! , email: emailField.text!, password: passwordField.text!, phoneNumber: numberField.text!)
                indicator.stopAnimating()
                indicator.isHidden = true
                let alert = UIAlertController(title:"Successful", message: "Save successful", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
                alert.addAction(okButton)
                self.performSegue(withIdentifier: "goLogin", sender: nil)
                self.present(alert, animated: true)
               // showAlert(message: "kaydetme işlemi başarılı")
                
            }
            
        }
        
        //  saveDataToFirestore()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // user alanına kaydetme
    func saveUserToFirestore(username: String, email: String, password: String,  phoneNumber : String) {
        let db = Firestore.firestore()
        
        let userDocument = db.collection("users").document()
        
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "phoneNumber" : phoneNumber
        ]
        
        userDocument.setData(userData) { error in
            if let error = error {
                // Hata durumu
                print("Hata: \(error.localizedDescription)")
            } else {
                // Başarılı durumu
                print("Kullanıcı bilgileri Firestore veritabanına kaydedildi.")
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

extension RegisterScreenViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = "5"
        return true
    }
    //telefon numarası alanına tıklayınca otomatik 5 yazıp toplam 10 karakter girmesi
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
       
        
        if updatedText.count > 10 {
            // 10 karakterden fazla giriş yapılmasına izin verme
            return false
        }
        
        return true
    }
    
}
