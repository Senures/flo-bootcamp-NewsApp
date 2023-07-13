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
        print("favori listesi uzunlugu : \(favoriteList.count)")
        print("object listesi uzunlugu : \(objectList.count)")
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

    
  /*  override func viewDidAppear(_ animated: Bool) {
        print("=================  VIEW DID APPEAR")
        print(favoriteList.count)
        print(objectList.count)
        favoriteList.removeAll()
        objectList.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                objectList.append(result)
                if let news_title = result.value(forKey: "news_title") as? String,
                   let img = result.value(forKey: "img") as? String,
                   let id = result.value(forKey: "id") as? String,
                   let news_author = result.value(forKey: "news_author") as? String,
                   let news_content = result.value(forKey: "news_content") as? String,
                   let source_name = result.value(forKey: "source_name") as? String,
                   let description = result.value(forKey: "news_description") as? String,
                   let news_url = result.value(forKey: "news_url") as? String {
                    
                    let news = FavoriteNewsModel(source: source_name, author: news_author, title: news_title, description: description, url: news_url, urlToImage: img, publishedAt: id, content: news_content)
                    favoriteList.append(news)
                }
            }
            self.favoriteTableView.reloadData()
            updateView()
            print("favori listesi uzunlugu : \(favoriteList.count)")
            print("object listesi uzunlugu : \(objectList.count)")
            
        } catch {
            print("error")
        }
    }*/
    
    
    func updateView() {
        if objectList.isEmpty {
            favoriteTableView.isHidden = true
            emptyListLabel.isHidden = false
            deleteBtn.isHidden = true
        } else {
            favoriteTableView.isHidden = false
            emptyListLabel.isHidden = true
        }
    }
    
    
}

extension FavoriteScreenViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count ?? 2
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"favCell", for: indexPath) as! FavoriteCell
        
        cell.title.text = favoriteList[indexPath.row].title
        cell.img.kf.setImage(with: URL(string:favoriteList[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
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
            dvc?.newsResponseModel = sender as? Article
            
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
        print(favoriteList.count)
        // Değişiklikleri kaydetme
        do {
            try context.save()
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
