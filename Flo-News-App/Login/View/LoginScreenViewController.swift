//
//  LoginScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 20.06.2023.
//

import UIKit
import Firebase

protocol LoginScreenViewControllerProtocol : AnyObject {
    func setupUI()
    func showPassword()
}

final class LoginScreenViewController : UIViewController, LoginScreenViewControllerProtocol {

    private lazy var  viewModel = LoginViewModel()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var forgotPasBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var showPassBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
 
    
    let closeEye = UIImage(named: "close")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //MARK: Sayfadan çıkıldığında tetxfield'ların içeriğini temizler
        emailField.text = ""
        passwordField.text = ""
        
    }
    
    func setupUI(){
        emailField.textColor = .black
        passwordField.textColor = .black
        loginBtn.applyCornerRadius(5.0)
        passwordField.isSecureTextEntry = true
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        validateTextFields()
    }
    @IBAction func goRegisterPage(_ sender: Any) {
        performSegue(withIdentifier:"goRegister", sender: nil)
        
    }
    @IBAction func forgotPassClick(_ sender: Any) {
        performSegue(withIdentifier: "resetPassword", sender:nil)
    }
    // butona basınca şifre gösterilmesi
    @IBAction func showPassBtn(_ sender: Any) {
        showPassword()
        
    }
    
    //şifre gösterilmesi
    func showPassword(){
        viewModel.isShowPassword = !viewModel.isShowPassword
        print("\(viewModel.isShowPassword)")
        if viewModel.isShowPassword {
            passwordField.isSecureTextEntry = false
            showPassBtn.setImage(closeEye, for: .normal)
            
        } else {
            passwordField.isSecureTextEntry = true
            showPassBtn.setImage(UIImage(named: "eye"), for: .normal)
            
        }
    }
 
    
   func validateTextFields(){
        if let email = emailField.text {
            if email.isEmpty {
                AlertUtils.showAlert(from: self,withMessage: "Please enter your email")
            }
        }
        if let password = passwordField.text {
            if password.isEmpty {
                AlertUtils.showAlert(from: self,withMessage: "Please enter password")
            }
        }
        showActivityIndicator()
        Auth.auth().signIn(withEmail:emailField.text!, password: passwordField.text!) { (authResult, error) in
            if error != nil {
                self.hideActivityIndicator()
                AlertUtils.showCustomAlert(from: self, title:"Error", message: error?.localizedDescription ?? "Error")
            } else{
                self.hideActivityIndicator()
                print("kullanıcı oluşturulduuu")
                self.performSegue(withIdentifier:"goHome", sender: nil)
            }
            
        }
    
    }
}


