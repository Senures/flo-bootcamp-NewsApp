//
//  FavoriteScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import UIKit
import CoreData

class FavoriteScreenViewController: UIViewController {
    
    @IBAction func deleteBtnClick(_ sender: Any) {
        let alertController = UIAlertController(title: "Silme İşlemi", message: "Tüm verileri silmek istediğinize emin misiniz?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { (_) in
                self.deleteAllData()
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var emptyListLabel: UIStackView!
    var favoriteList: [FavoriteNewsModel] = []
    
    
    var objectList : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // CoreData'dan verileri çekme
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            
            // objectList'i güncelle
            objectList = results as! [NSManagedObject]
            
            // favoriteList'i güncelle
            favoriteList = objectList.compactMap { result in
                if let news_title = result.value(forKey: "news_title") as? String,
                   let img = result.value(forKey: "img") as? String,
                   let id = result.value(forKey: "id") as? String,
                   let news_author = result.value(forKey: "news_author") as? String,
                   let news_content = result.value(forKey: "news_content") as? String,
                   let source_name = result.value(forKey: "source_name") as? String,
                   let description = result.value(forKey: "news_description") as? String,
                   let news_url = result.value(forKey: "news_url") as? String {
                    
                    return FavoriteNewsModel(source: source_name, author: news_author, title: news_title, description: description, url: news_url, urlToImage: img, publishedAt: id, content: news_content)
                }
                
                return nil // Nil değeri dönerek favori haber modelini atla
            }
            
            // TableView'ı güncelle
            favoriteTableView.reloadData()
            updateView()
        } catch {
            print("CoreData'dan veri çekme hatası: \(error)")
        }
    }
    
    //liste bos ise cöp kutusu ve liste bos yazısı gözükmesi
    func updateView() {
        if objectList.isEmpty || favoriteList.isEmpty {
            favoriteTableView.isHidden = true
            emptyListLabel.isHidden = false
            deleteBtn.isHidden = true
        } else {
            favoriteTableView.isHidden = false
            emptyListLabel.isHidden = false
            deleteBtn.isHidden = false
        }
    }
    //core datadaki tüm verileri silme
    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            favoriteList.removeAll()
            favoriteTableView.reloadData()
            updateView()
        } catch {
            print("Core Data'da hata oluştu: \(error)")
        }
    }

}

extension FavoriteScreenViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count ?? 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"favCell", for: indexPath) as! FavoriteCell
        
        cell.title.text = favoriteList[indexPath.row].title
        cell.img.kf.setImage(with: URL(string:favoriteList[indexPath.row].urlToImage ??  Constants.emptyUrlImage), placeholder:UIImage(named:"image"))
        cell.descriptionLbl.text = favoriteList[indexPath.row].description
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = favoriteList[indexPath.row]
        self.performSegue(withIdentifier: "goDetail", sender: data)
    }
    
    //DİĞER SAYFANIN CONTROLLERINDA  VERİYİ ALMAK İÇİN
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            
            let dvc = segue.destination as? DetailScreenViewController
            let a  = sender as?  FavoriteNewsModel
            var b  = Article(source: Source(id: "",name: ""), author: a?.author,title:  a?.title, description: a?.description, url: a?.url, urlToImage: a?.urlToImage, publishedAt: a?.publishedAt,content: a?.content )
          
            dvc?.newsResponseModel = b
            
            print(a?.title)
            print(dvc?.newsResponseModel?.title)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    //coredatadan silme işlemi
    func deleteItem(at indexPath: IndexPath) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        
        
        // let favoriteObject : NSManagedObject = favoriteList[indexPath.row]
        //let favoriteObject = favoriteList[indexPath.row] as? NSManagedObject
        
        guard let favObj = objectList[indexPath.row] as? NSManagedObject else { return }
        
        // Core Data'dan öğeyi silme işlemi
        context.delete(favObj)
        
        // Favori listesinden öğeyi kaldırma
        favoriteList.remove(at: indexPath.row)
        
        // TableView'daki öğeyi güncelleme
        favoriteTableView.deleteRows(at: [indexPath], with: .fade)
        
        // TableView'i güncelleme
        favoriteTableView.reloadData()
        
        // Değişiklikleri kaydetme
        do {
            try context.save()
            updateView()
        } catch {
            print("Core Data'da hata oluştu: \(error)")
        }
        
        
        
        //if let favorite = favoriteObject as? FavoriteNewsModel {
        
        // }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Silme işlemi için UIContextualAction oluştur
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            // Silme işlemini burada gerçekleştirin
            self?.deleteItem(at: indexPath)
            completionHandler(true)
        }
        
        
        // Silme arka plan rengini turuncu olarak ayarla
        deleteAction.backgroundColor = .systemOrange
        
        // Silme işlemini içeren UISwipeActionsConfiguration oluştur ve döndür
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
