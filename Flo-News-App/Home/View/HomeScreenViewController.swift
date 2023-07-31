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
    @IBOutlet weak var trendingNewsLbl: UILabel!
    @IBOutlet weak var recommandationLbl: UILabel!
    @IBOutlet weak var recommendCv: UICollectionView!
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let emptyData = UILabel()
    var topHeadList: [Article] = []
    var trendNewsList: [Article] = []
    var recommendationList: [Article] = []
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        viewModel.delegate = self
        //MARK: Collectionview delegate islemleri
        collectionViewSet()
        
        todayDate()
        greetMessage()
        emptyDataHidden()
        pageControl.currentPage = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        showActivityIndicator()
        viewModel.fetchTrendNews()
        viewModel.fetchTopHeadlines()
        viewModel.fetchRecommendationNews()
    }
    
    private func todayDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "E MMMM, yyyy"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        todayDateLbl.text = formattedDate
        
    }
    private func emptyDataHidden(){
        emptyData.text = "Data could not be loaded"
        emptyData.textColor = UIColor.systemOrange
        emptyData.textAlignment = .center
        emptyData.font = UIFont.systemFont(ofSize: 22)
        emptyData.sizeToFit()
        
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        emptyData.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        emptyData.isHidden = true
        view.addSubview(emptyData)
    }
    
    private func greetMessage(){
       let currentDate = Date()
       let calendar = Calendar.current
       let hour = calendar.component(.hour, from: currentDate)
       if hour >= 6 && hour < 12 {
           greetingMessage.text = "Good Morning !"
       } else if hour >= 18 || hour < 6 {
           greetingMessage.text = "Good Night !"
       } else {
           greetingMessage.text = "Hello !"
       }
   }
    
    //MARK: delegate bağlama işlemleri
    func collectionViewSet() {
        topHeadCollectionView.dataSource = self
        topHeadCollectionView.delegate = self
        trendCollectionView.dataSource = self
        trendCollectionView.delegate = self
        recommendCv.delegate = self
        recommendCv.dataSource = self
    }
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topHeadCollectionView {
            return topHeadList.count
        } else if collectionView == trendCollectionView {
            return trendNewsList.count
        } else {
            return recommendationList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topHeadCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topHeadCV", for: indexPath) as! TopHeadlineCollectionViewCell
            cell.image.kf.setImage(with: URL(string: topHeadList[indexPath.row].urlToImage ?? Constants.emptyUrlImage), placeholder: UIImage(named: "image"))
            cell.image.layer.cornerRadius = 10
            return cell
        } else if collectionView == trendCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendCell", for: indexPath) as! TrendCollectionViewCell
            cell.img.kf.setImage(with: URL(string: trendNewsList[indexPath.row].urlToImage ?? Constants.emptyUrlImage), placeholder: UIImage(named: "image"))
            cell.lbl.text = trendNewsList[indexPath.row].title
            cell.sourceLbl.text = trendNewsList[indexPath.row].source?.name ?? "The Wall Street"
            cell.img.layer.cornerRadius = 5
            cell.layer.cornerRadius = 10
            return cell
        } else if collectionView == recommendCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! RecommendCollectionViewCell
            cell.img.kf.setImage(with: URL(string: recommendationList[indexPath.row].urlToImage ?? Constants.emptyUrlImage), placeholder: UIImage(named: "image"))
            cell.img.layer.cornerRadius = 5
            cell.title.text = recommendationList[indexPath.row].title
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topHeadCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == trendCollectionView {
            return CGSize(width: 280, height: 200)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendCollectionView {
            let data = trendNewsList[indexPath.row]
            self.performSegue(withIdentifier: "goDetail", sender: data)
        } else if collectionView == topHeadCollectionView {
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
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}


extension HomeScreenViewController: HomeViewModelDelegate {
    func trendNewsFetched(_ articles: [Article]) {
        trendNewsList = articles
        self.hideActivityIndicator()
        DispatchQueue.main.async {
            self.trendCollectionView.reloadData()
        }
        pageControl.numberOfPages = topHeadList.count ?? 0
    }
    
    func topHeadlinesFetched(_ articles: [Article]) {
        topHeadList = articles
        DispatchQueue.main.async {
            self.topHeadCollectionView.reloadData()
        }
    }
    
    func recommendationNewsFetched(_ articles: [Article]) {
        recommendationList = articles
        DispatchQueue.main.async {
            self.recommendCv.reloadData()
        }
    }
}


