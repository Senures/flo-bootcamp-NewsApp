//
//  RegisterScreenViewModel.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 20.07.2023.
//

import Foundation
import Firebase


protocol RegisterScreenViewModelProtocol {
    
    var view : RegisterScreenControllerProtocol? { get set }
    
    func viewDidLoad()
    func saveUserToFirestore(username: String, email: String, password: String, phoneNumber: String)
    
}

class RegisterScreenViewModel: RegisterScreenViewModelProtocol {
  
    
    weak var view: RegisterScreenControllerProtocol?
    func viewDidLoad() {
        
        view?.setupUI()
       
    }
    //MARK: firebasede user koleksiyonuna  kaydetme işlemi
    func saveUserToFirestore(username: String, email: String, password: String, phoneNumber: String) {
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document()
        let currentUsers = Auth.auth().currentUser?.uid
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "phoneNumber" : phoneNumber,
            "userId" : currentUsers
        ]
        
        userDocument.setData(userData) { error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            } else {
                self.view?.succesfulRegisterAlert()
                print("Kullanıcı bilgileri Firestore veritabanına kaydedildi.")
            }
        }
    }
    
}
