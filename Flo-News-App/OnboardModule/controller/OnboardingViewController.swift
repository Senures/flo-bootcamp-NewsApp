//
//  OnboardingViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 13.06.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var showBoard = true
    var slides: [OnboardingModel] = []
    var img1 = UIImage(named: "resim3")
    var img2 = UIImage(named: "es1")
    var img3 = UIImage(named: "es5")
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                nextBtn.setTitle("Get Started", for:.normal)
                
            } else {
                nextBtn.setTitle("Next", for:.normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        collectionViewSet()
        slides = [
            OnboardingModel(title: "Read news with only one app, News App", descriptiom: "Read the latest news smoothly and quickly at the same time", image:img1!),
            OnboardingModel(title: "Read news with only one app, News App", descriptiom: "Read the latest news smoothly and quickly at the same time", image:img2!),
            OnboardingModel(title: "Read news with only one app, News App", descriptiom: "Read the latest news smoothly and quickly at the same time", image:img3!),
        ]
    }
    private func setUI(){
        nextBtn.backgroundColor = hexStringToUIColor(hex: "#FFA500")
        nextBtn.applyCornerRadius(10)
    }
    
    private func collectionViewSet(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    @IBAction func nextBtnClick(_ sender: Any) {
        if currentPage == slides.count - 1 {
            //burda login olma sayfasına gidicek
            UserDefaults.standard.set(showBoard, forKey: "showOnboard")
            //onboard gösterilcek mi kısmı
            performSegue(withIdentifier: "goLogin", sender:nil)
            print("STORYBOARD GO LOGIN GİTMESİ GEREKİYOR")
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section:0)
            nextBtn.setTitleColor(.white, for:.normal)
            collectionView.scrollToItem(at: indexPath, at:.centeredHorizontally, animated: true)
            print("STORYBOARD NEXT")
        }
    }
    
    
}


extension OnboardingViewController : UICollectionViewDelegate, UICollectionViewDataSource ,
                                     UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"onboardCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
        
    }
    
}
