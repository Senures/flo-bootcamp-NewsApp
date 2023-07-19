//
//  HomeScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 24.06.2023.
//

import UIKit
import Firebase
import Kingfisher

class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var greetingMessage: UILabel!
    @IBOutlet weak var topHeadCollectionView: UICollectionView!
    @IBOutlet weak var trendCollectionView: UICollectionView!
    @IBOutlet weak var recommendCv: UICollectionView!
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //topheadline listesi en bastaki collection view
    var topHeadList:[Article] = []
    var trendNewsList:[Article] = []
    var recommendationList:[Article] = []
    
    override func viewWillAppear(_ animated: Bool) {
     
        fetchTrendNews()
        fetchTopHeadlines()
        fetchRecommendationNews()
        
    }
    
    private func fetchTrendNews(){
        
       showActivityIndicator()
        ApiClient.apiClient.fetchTrendNews{ response in
            if let articles = response.articles, !articles.isEmpty {
               
                self.trendNewsList = articles
                self.hideActivityIndicator()
                self.reloadCollectionView()
              
                
                self.pageControl.numberOfPages = self.topHeadList.count ?? 0
                
            } else {
       
                print("API'den veri alınamadı veya veri boş.")
            }
            
            
        }
    }
    
    private func fetchTopHeadlines(){
    
        ApiClient.apiClient.fetchTopHeadLines { response in
            if let articles = response.articles, !articles.isEmpty {
               
                self.topHeadList = articles
      
                self.topHeadCollectionView.reloadData()
                
                self.recommendCv.reloadData()
          
            } else {
              
                print("API'den veri alınamadı veya veri boş.")
            }
            
            
        }
    }
    
    private func fetchRecommendationNews(){

        ApiClient.apiClient.fetchRecommendationNews { response in
            if let articles = response.articles, !articles.isEmpty {
          
                self.recommendationList = articles
              
                self.recommendCv.reloadData()
            
            } else {
               
                print("API'den veri alınamadı veya veri boş.")
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topHeadCollectionView.dataSource = self
        topHeadCollectionView.delegate = self
        
        topHeadCollectionView.reloadData()
        
        
        trendCollectionView.dataSource = self
        trendCollectionView.delegate = self
        
        trendCollectionView.reloadData()
        
        recommendCv.delegate = self
        recommendCv.dataSource = self
        
        recommendCv.reloadData()
        
        todayDate()
        greetMessage()
        
        
        
        pageControl.currentPage = 0
        
       
    }
    
    
    
    
   
    
    private func greetMessage(){
        // Şu anki tarih ve saat bilgisini alın
        let currentDate = Date()
        
        // Takvim nesnesini oluşturun
        let calendar = Calendar.current
        
        // Şu anki saati alın
        let hour = calendar.component(.hour, from: currentDate)
        
        // Saate göre mesajı belirleyin
        
        
        if hour >= 6 && hour < 12 {
            greetingMessage.text = "Good Morning !"
        } else if hour >= 18 || hour < 6 {
            greetingMessage.text = "Good Night !"
        } else {
            greetingMessage.text = "Hello !"
        }
        
        // Mesajı ekrana yazdırın
        print(greetingMessage.text)
    }
    private func todayDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "E MMMM, yyyy"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        todayDateLbl.text = formattedDate
        
    }
    
    func reloadCollectionView() {
        
        DispatchQueue.main.async {
            self.trendCollectionView.reloadData()
        }
        //reload ile ui yenileniyor güncel tutuyor o yüzden main threadde olmasını sağlıyor
    }
    
    
}

extension HomeScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource ,
                                     UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topHeadCollectionView {
            return topHeadList.count ?? 0
        } else  if collectionView == trendCollectionView {
            return trendNewsList.count ?? 0
        } else {
            return recommendationList.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topHeadCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"topHeadCV", for: indexPath) as! TopHeadlineCollectionViewCell
            
            cell.image.kf.setImage(with: URL(string: topHeadList[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.image.layer.cornerRadius = 10
            return cell
        } else if  collectionView == trendCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendCell", for: indexPath) as! TrendCollectionViewCell
            cell.img.kf.setImage(with: URL(string: trendNewsList[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.lbl.text = trendNewsList[indexPath.row].title
            cell.sourceLbl.text = trendNewsList[indexPath.row].source?.name ?? "The Wall Street"
            cell.img.layer.cornerRadius = 5
            cell.layer.cornerRadius = 10
            
            return cell
            
            
        } else if  collectionView == recommendCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! RecommendCollectionViewCell
            cell.img.kf.setImage(with: URL(string: recommendationList[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.img.layer.cornerRadius = 5
            cell.title.text = recommendationList[indexPath.row].title
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topHeadCollectionView {
            return CGSize(width:collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == trendCollectionView {
            return CGSize(width:180, height: collectionView.frame.height)
           
        } else {
            return CGSize(width:collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
    
    //TIKLANDIGINDA VERİYİ GÖNDERİCEM MODELİ GÖNDERCEM
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == trendCollectionView {
            let data = trendNewsList[indexPath.row]
            self.performSegue(withIdentifier: "goDetail", sender: data)
        } else  if collectionView == topHeadCollectionView{
            let data = topHeadList[indexPath.row]
            self.performSegue(withIdentifier: "goDetail", sender: data)
        } else if collectionView == recommendCv {
            let data = recommendationList[indexPath.row]
            self.performSegue(withIdentifier: "goDetail", sender: data)
        }
        
    }
    
    
    
    //DİĞER SAYFANIN CONTROLLERINDA  VERİYİ ALMAK İÇİN
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            
            let dvc = segue.destination as? DetailScreenViewController
            dvc?.newsResponseModel = sender as? Article
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // let width = scrollView.frame.width
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        // pageControl.currentPage = currentPage
    }
    
}

