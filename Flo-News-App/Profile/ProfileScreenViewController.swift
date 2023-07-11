//
//  ProfileScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import UIKit
import Firebase

class ProfileScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cikisYap(_ sender: Any) {
        do {
                try Auth.auth().signOut()
                // Oturum başarıyla kapatıldı
                
                // Oturumu kapattıktan sonra yapılmasını istediğiniz işlemleri burada gerçekleştirin.
                // Örneğin, kullanıcıyı giriş ekranına yönlendirebilirsiniz.
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginController = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
                UIApplication.shared.windows.first?.rootViewController = loginController
            } catch let error as NSError {
                print("Oturum kapatma hatası: \(error.localizedDescription)")
            }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
