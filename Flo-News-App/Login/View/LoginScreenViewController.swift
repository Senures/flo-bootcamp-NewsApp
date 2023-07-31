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
   
}

final class LoginScreenViewController : UIViewController, LoginScreenViewControllerProtocol {
   
    private lazy var  viewModel = LoginViewModel()
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var forgotPasBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
   let iconView = UIButton(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
   
    let closeEye = UIImage(named: "close")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        setRightIcon()
        
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
    
    //password gösterilmesi butonu
    
    func setRightIcon(){
        iconView.setImage(UIImage(named: "close"), for: UIControl.State.normal)
        iconView.contentMode = .center
        iconView.tintColor = .black
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 35, height: 35))
        iconContainerView.contentMode = .center
        iconContainerView.addSubview(iconView)
        passwordField.rightView = iconContainerView
        passwordField.rightViewMode = .always
        
        iconView.addTarget(self, action: #selector(changePassHidden), for: .touchDown)
    }
    //butona basınca şifre gösterilmesi
    @objc func changePassHidden(){
        viewModel.isShowPassword = !viewModel.isShowPassword
        passwordField.isSecureTextEntry = viewModel.isShowPassword
        if viewModel.isShowPassword {
            iconView.setImage(UIImage(named: "close"), for: UIControl.State.normal)
        }else{
            iconView.setImage(UIImage(named: "eye"), for: UIControl.State.normal)
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


