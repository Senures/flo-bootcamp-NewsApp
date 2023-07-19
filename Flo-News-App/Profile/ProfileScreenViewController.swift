//
//  ProfileScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import UIKit
import Firebase

class ProfileScreenViewController: UIViewController {
    
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var profileView: UIView!
    
   
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton! {
        didSet {
            updateBtn.isHidden = true
        }
    }
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.backgroundColor = UIColor.black
        profileView.layer.cornerRadius = 15.0
        
        signOutBtn.applyCornerRadius(5.0)
        email.layer.borderColor = UIColor.gray.cgColor
        email.layer.borderWidth = 1.0
        email.layer.cornerRadius = 5.0
        userName.layer.borderColor = UIColor.gray.cgColor
        userName.layer.borderWidth = 1.0
        userName.layer.cornerRadius = 5.0
        phoneNumber.layer.borderColor = UIColor.gray.cgColor
        phoneNumber.layer.borderWidth = 1.0
        phoneNumber.layer.cornerRadius = 5.0
        
        getData()
        
    }
    
    
    @IBAction func updateBtnClick(_ sender: Any) {
        
        showActivityIndicator()
        // Firestore bağlantısı
        let db = Firestore.firestore()

        // Kullanıcının kimliği (örnek olarak, oturum açan kullanıcının kimliği)
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış.")
            return
        }

        // Güncellemek istediğiniz veriyi alın
        let usersRef = db.collection("users")

        usersRef.whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Sorgu hatası: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("Belge yok")
                return
            }

            // Sorgu sonucu elde edilen belgeleri alıyoruz (Bu örnekte sadece bir belgeyi alıyoruz)
            let document = documents[0]

            // Güncellemek istediğiniz veriyi hazırlayın
            var updatedData = document.data()
            updatedData["username"] = self.userName.text
            updatedData["phoneNumber"] = self.phoneNumber.text

            // Veriyi güncelle
            usersRef.document(document.documentID).setData(updatedData) { [self] error in
                if let error = error {
                    print("Veri güncellenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    
                    print("Veri başarıyla güncellendi.")
                    self.userName.isUserInteractionEnabled = false
                    self.phoneNumber.isUserInteractionEnabled = false
                    updateBtn.isHidden = true
                    showSuccessAlert()
                    userName.layer.borderColor = UIColor.gray.cgColor
                    phoneNumber.layer.borderColor = UIColor.gray.cgColor
                }
            }
        }
        self.hideActivityIndicator()
    }
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Your data has been updated.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Geçerli görünümün üzerine alerti ekleyelim
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func signOutClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
            UIApplication.shared.windows.first?.rootViewController = loginController
        } catch let error as NSError {
            print("Oturum kapatma hatası: \(error.localizedDescription)")
        }
    }
   
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func updateForm(_ sender: Any) {
        updateBtn.isHidden = false
        userName.layer.borderColor = UIColor.white.cgColor
        phoneNumber.layer.borderColor = UIColor.white.cgColor
        userName.isUserInteractionEnabled = true
        phoneNumber.isUserInteractionEnabled = true
    }
    
    func getData(){
        print("GET DATA ÇALIŞTI")
        showActivityIndicator()
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document()
        print("1111")
        let userId = Auth.auth().currentUser?.uid
        db.collection("users").whereField("userId", isEqualTo:userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Sorgu hatası: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("Belge yok")
                return
            }
            
            // Döngü kullanarak sorgu sonucu elde edilen belgeleri alıyoruz
            for document in documents {
                let data = document.data()
                
                if let username = data["username"] as? String {
                    DispatchQueue.main.async {
                        print("Kullanıcının ismi: \(username)")
                        self.userName.text = username
                    }
                }
                if let emailF = data["email"] as? String {
                    DispatchQueue.main.async {
                        print("Kullanıcının email'i: \(emailF)")
                        self.email.text = emailF
                    }
                }
                if let phoneNumberF = data["phoneNumber"] as? String {
                    DispatchQueue.main.async {
                        print("Kullanıcının telefon numarası: \(phoneNumberF)")
                        self.phoneNumber.text = phoneNumberF
                    }
                }
            }
            self.hideActivityIndicator()
        }
     
    }
}


