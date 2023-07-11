//
//  DetailScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 26.06.2023.
//

import UIKit
import CoreData

class DetailScreenViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    @IBOutlet weak var image: UIImageView!
    var newsResponseModel : Article?
    
    @IBOutlet weak var sourceLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var saveNewsBtn: UIButton!
    var isFav: Bool = false
    
    func changeFavButton(){
        if isFav == true {
            
            saveNewsBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else{
            saveNewsBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    @IBOutlet weak var author: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        if let url = URL(string: newsResponseModel?.url ?? "") {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveNewsBtn(_ sender: Any) {
        
        
        
        if isFav {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results as! [NSManagedObject] {
                    if let newsID = result.value(forKey: "id")  as? String {
                        print("IDD ==== \(newsID)")
                        
                        if newsResponseModel?.publishedAt == newsID {
                            context.delete(result)
                            isFav = false
                            changeFavButton()
                        }
                    }
                }
                
            } catch {
                print("errır")
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let news = NSEntityDescription.insertNewObject(forEntityName: "FavoriteList", into: context)
            //photo bu coredatadaki isminin adı
            news.setValue(newsResponseModel?.title, forKey: "news_title")
            news.setValue(newsResponseModel?.urlToImage, forKey: "img")
            news.setValue(newsResponseModel?.publishedAt, forKey: "id")
            news.setValue(newsResponseModel?.author, forKey: "news_author")
            news.setValue(newsResponseModel?.description, forKey: "news_content")
          news.setValue(newsResponseModel?.source?.name, forKey: "source_name")
            news.setValue(newsResponseModel?.url, forKey: "news_url")
            news.setValue(newsResponseModel?.description, forKey: "news_description")
           
            do {
                try context.save()
                isFav = true
                changeFavButton()
                print("SUCCESS")
            }catch {
                print("ERROR")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        image.kf.setImage(with: URL(string: newsResponseModel?.urlToImage ?? ""), placeholder:UIImage(named:"image"))
        
        //veri cagırmakkk
                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      let context = appDelegate.persistentContainer.viewContext
                      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteList")
                      fetchRequest.returnsObjectsAsFaults = false
                      do {
                          let results = try context.fetch(fetchRequest)
                          
                          for result in results as! [NSManagedObject] {
                              if let name = result.value(forKey: "img")  as? String {
                                  print("NAME ==== \(name)")
                              }
                              if let newsID = result.value(forKey: "id")  as? String {
                                  print("IDD ==== \(newsID)")
                                  
                                  if newsResponseModel?.publishedAt == newsID {
                                      isFav = true
                                      changeFavButton()
                                  }
                              }
                          }
                          
                      } catch {
                          print("errır")
                      }
    }
    
    @IBAction func goToWebView(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Read More", message: "Do you want to go to the web page?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [self] _ in
            if let url = URL(string: self.newsResponseModel?.url ?? "https://www.google.com/") {
                let webViewViewController = WebViewController(url: url)
                present(webViewViewController, animated: true, completion: nil)
            }
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func setData(){
        image.layer.cornerRadius = 5
        titleLbl.text = newsResponseModel?.title ?? "Title"
        sourceLbl.text = newsResponseModel?.source?.name ?? "BBC"
        author.text = newsResponseModel?.author ?? "Mehmet Ali Brand"
        contentLbl.text = newsResponseModel?.description ?? "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English"
    }
    
}







