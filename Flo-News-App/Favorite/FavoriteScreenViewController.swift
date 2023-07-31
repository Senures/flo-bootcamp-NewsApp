//
//  FavoriteScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import UIKit
import CoreData

class FavoriteScreenViewController: UIViewController {
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var emptyListLabel: UIStackView!
    var favoriteList: [FavoriteNewsModel] = []
    
    
    var objectList : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       delegateTableView()
        
    }
    private func delegateTableView(){
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
    }
   
    @IBAction func deleteBtnClick(_ sender: Any) {
        //tüm favori listesini silme işlemi
        let alertController = UIAlertController(title: "To Delete", message: "Are you sure you want to delete all data?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.deleteAllData()
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
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
                
                return nil 
            }
            
            // TableView'ı güncelle
            favoriteTableView.reloadData()
            updateView()
        } catch {
            print("CoreData'dan veri çekme hatası: \(error)")
        }
    }
    
    //liste bos ise cöp kutusu ve liste bos yazısı gözükmesi
    private func updateView() {
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
    private func deleteAllData() {
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
            let response  = sender as?  FavoriteNewsModel
            var result  = Article(source: Source(id: "",name: ""), author: response?.author,title:  response?.title, description: response?.description, url: response?.url, urlToImage: response?.urlToImage, publishedAt: response?.publishedAt,content: response?.content )
          
            dvc?.newsResponseModel = result
        
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
    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            
            self?.deleteItem(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemOrange
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
