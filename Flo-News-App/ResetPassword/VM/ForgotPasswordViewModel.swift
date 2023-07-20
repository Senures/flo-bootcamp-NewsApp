//
//  ForgotPasswordViewModel.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 20.07.2023.
//

import Foundation
import Firebase


protocol ForgotPasswordViewModelProtocol {
  
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
  
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
