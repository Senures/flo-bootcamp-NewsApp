//
//  ForgotPasswordViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 22.06.2023.
//

import UIKit
import Firebase
import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendMailBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    
    var viewModel: ForgotPasswordViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMailBtn.applyCornerRadius(5.0)
        viewModel = ForgotPasswordViewModel()
    }
    
    @IBAction func sendMail(_ sender: Any) {
        if let emailField = email.text {
            if emailField.isEmpty {
                AlertUtils.showAlert(from: self, withMessage: "Please enter your e-mail address")
            } else {
                self.showActivityIndicator()
                viewModel.resetPassword(email: email.text!) { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        switch result {
                        case .success:
                            AlertUtils.showSuccessAlert(from: self, withMessage: "Password reset email has been sent.") {
                                self.dismiss(animated: true)
                            }
                          
                        case .failure(let error):
                            AlertUtils.showCustomAlert(from: self, title: "Error", message: error.localizedDescription)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
   
}

