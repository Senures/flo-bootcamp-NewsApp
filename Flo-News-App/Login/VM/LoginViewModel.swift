//
//  LoginViewModel.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 11.07.2023.
//

import Foundation
import Firebase



protocol LoginViewModelProtocol {
    var view : LoginScreenViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class LoginViewModel : LoginViewModelProtocol {
 
    weak  var view: LoginScreenViewControllerProtocol?
    var isShowPassword : Bool = false

    func viewDidLoad() {
        view?.setupUI()
        
    }
  
}

