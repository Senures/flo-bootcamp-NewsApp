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
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var updateBtn: UIButton! {
        didSet {
            updateBtn.isHidden = true
        }
    }
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getData()
        
    }
    
    private func setUI(){
        
        editBtn.backgroundColor = hexStringToUIColor(hex: "#FFa500")
        updateBtn.backgroundColor = hexStringToUIColor(hex: "#FFa500")
        editBtn.applyCornerRadius(15.0)
        updateBtn.applyCornerRadius(20.0)
        signOutBtn.applyCornerRadius(5.0)
        
        userName.layer.borderColor = UIColor.gray.cgColor
        userName.layer.borderWidth = 1.0
        userName.layer.cornerRadius = 5.0
        phoneNumber.layer.borderColor = UIColor.gray.cgColor
        phoneNumber.layer.borderWidth = 1.0
        phoneNumber.layer.cornerRadius = 5.0
    }
    
    //MARK: data güncelleme işlemi
    @IBAction func updateBtnClick(_ sender: Any) {
        showActivityIndicator()
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış.")
            return
        }
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
            
            let document = documents[0]
            var updatedData = document.data()
            updatedData["username"] = self.userName.text
            updatedData["phoneNumber"] = self.phoneNumber.text
            
            // Veriyi güncelle
            usersRef.document(document.documentID).setData(updatedData) { [self] error in
                if let error = error {
                    print("Veri güncellenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    
                    print("Veri başarıyla güncellendi.")
                    showSuccessAlert()
                    self.userName.isUserInteractionEnabled = false
                    self.phoneNumber.isUserInteractionEnabled = false
                    updateBtn.isHidden = true
                    
                    userName.layer.borderColor = UIColor.gray.cgColor
                    phoneNumber.layer.borderColor = UIColor.gray.cgColor
                    signOutBtn.isHidden = false
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
        
        showLogoutAlert()

    }
    //cıkıs yapmak istediginizden emin misiniz alerti
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Flo News App", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .default) { [weak self] _ in
            self?.performLogout()
        }
        alert.addAction(logoutAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func performLogout() {
        showActivityIndicator()
        do {
            try Auth.auth().signOut()
            self.hideActivityIndicator()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
            UIApplication.shared.windows.first?.rootViewController = loginController
        } catch let error as NSError {
            print("Oturum kapatma hatası: \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func editBtnClick(_ sender: Any) {
        updateBtn.isHidden = false
        userName.layer.borderColor = UIColor.systemYellow.cgColor
        phoneNumber.layer.borderColor = UIColor.systemYellow.cgColor
        userName.isUserInteractionEnabled = true
        phoneNumber.isUserInteractionEnabled = true
        signOutBtn.isHidden = true
    }
    func getData(){
        print("GET DATA ÇALIŞTI")
        showActivityIndicator()
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document()
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
                        self.emailLbl.text = emailF
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


