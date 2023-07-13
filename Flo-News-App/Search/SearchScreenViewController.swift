//
//  SearchScreenViewController.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import UIKit
import SkeletonView

class SearchScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCv: UICollectionView!
    @IBOutlet weak var searchTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    //aramadan dönen liste
    var searchList : [Article]?
    private var filteredArticles: [Article] = []
    
    var searching:Bool?
    let categoryList = ["Business","Entertainment","General","Health","Science","Sports","Technology"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoryCv.delegate = self
        categoryCv.dataSource = self
        
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.reloadData()
        
     
            
           // searchController.searchResultsUpdater = self
     //   searchBar.searchTextField.backgroundColor = .black
        searchBar.barTintColor = UIColor.black// Arka plan rengi
      //searchBar.heightAnchor.constraint(equalToConstant: 120).isActive = true
        searchBar.searchTextField.backgroundColor = UIColor.white // Metin alanının arka plan rengi
        searchBar.searchTextField.textColor = UIColor.black // Metin rengi
        searchBar.searchTextField.tintColor = UIColor.black // V
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search"
            searchBar.delegate = self
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        categoryCv.reloadData()
        // Do any additional setup after loading the view.
        
     
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
       getSearhList()
        
    }
    
    func getSearhList(){
        
       // SkeletonView ayarları
     /*   searchTableView.isSkeletonable = true
        searchTableView.separatorStyle = .none
        searchTableView.showAnimatedSkeleton() */
     
        ApiClient.apiClient.search(params:"general") { response in
                     self.searchList = response.articles
                      self.searchTableView.hideSkeleton()
                     self.searchTableView.reloadData()
                     
                 }
       
    }
    
}

/*extension SearchScreenViewController : SkeletonTableViewDelegate , SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "searchCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false){
            return filteredArticles.count
        } else {
            return searchList?.count ?? 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"searchCell", for: indexPath) as! SearchTableViewCell

        if !(searching ??  false){
            cell.lbl.text = searchList?[indexPath.row].title
            cell.img.kf.setImage(with: URL(string:searchList?[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.dscriptionLbl.text = searchList?[indexPath.row].description
        } else {
            cell.lbl.text = filteredArticles[indexPath.row].title
            cell.img.kf.setImage(with: URL(string:filteredArticles[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.dscriptionLbl.text = filteredArticles[indexPath.row].description
        }
        
       /* // Hücre içeriğinin (contentView) kenar boşluklarını ayarla
           let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
           cell.contentInsets = contentInsets */
        
        // SkeletonView'i kaldır
        cell.contentView.hideSkeleton()
        
        return cell
    }
    
  
   
    
  /*  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTableView.isSkeletonable = true
        searchTableView.showAnimatedGradientSkeleton()
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = searchList?[indexPath.row]
        self.performSegue(withIdentifier: "goDetail", sender: data)
    }
    
    //DİĞER SAYFANIN CONTROLLERINDA  VERİYİ ALMAK İÇİN
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            
            let dvc = segue.destination as? DetailScreenViewController
            dvc?.newsResponseModel = sender as? Article
            
        }
    }
   
    
} */

extension SearchScreenViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false){
            return filteredArticles.count
        } else {
            return searchList?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"searchCell", for: indexPath) as! SearchTableViewCell

        if !(searching ??  false){
            cell.lbl.text = searchList?[indexPath.row].title
            cell.img.kf.setImage(with: URL(string:searchList?[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.dscriptionLbl.text = searchList?[indexPath.row].description
        } else {
            cell.lbl.text = filteredArticles[indexPath.row].title
            cell.img.kf.setImage(with: URL(string:filteredArticles[indexPath.row].urlToImage ?? ""), placeholder:UIImage(named:"image"))
            cell.dscriptionLbl.text = filteredArticles[indexPath.row].description
        }
      
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = searchList?[indexPath.row]
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
}


extension SearchScreenViewController :  UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCv.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryViewCell
        
        cell.categoryName.text = categoryList[indexPath.row]
        // cell.contentView.layer.cornerRadius = 5
        cell.categoryName.font = UIFont.systemFont(ofSize: 16)
        cell.categoryName.textColor = .white
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    //tıkladındıgında o indekste hangisi var bu bir yatayda kayan collectionview
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("*******************")
           guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else {
               return
           }
           
          //tıklanılan hücrelerin görünümü
          cell.categoryName.textColor = .orange
           cell.categoryName.font = UIFont.systemFont(ofSize: 16)
          cell.contentView.layer.borderWidth = 1.0 // Kenarlık kalınlığını belirleyin
           cell.contentView.layer.borderColor = UIColor.orange.cgColor
           cell.contentView.layer.cornerRadius = 10
           //cell.contentView.backgroundColor = .white
           print(categoryList[indexPath.row])
           //business general gibi yerlere basınca calısan api
                    ApiClient.apiClient.search(params:categoryList[indexPath.row]) { response in
                        self.searchList = response.articles
                        self.searchTableView.reloadData()
                        
                    }
                         
           //tıklanılmayan hücrelerin görünümü
           for visibleCell in collectionView.visibleCells {
               if let otherCell = visibleCell as? CategoryViewCell, otherCell != cell {
                 //otherCell.categoryName.textColor = .red
                   otherCell.categoryName.font = UIFont.systemFont(ofSize: 15)
                   otherCell.contentView.layer.borderWidth = 0.0 // Kenarlık kalınlığını sıfıra ayarlayın
                  otherCell.categoryName.textColor = .white
                  // otherCell.contentView.backgroundColor = .white
                   
               }
           }
           
          
       }
       
       
    
    
}

//categorilerin olduğu collection view
extension SearchScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 40)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        
        
    }
    
}

extension SearchScreenViewController : UISearchBarDelegate  {
    
    // Arama işlemini gerçekleştiren fonksiyonu çağırın
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Arama işlemini gerçekleştirin
        if let searchText = searchBar.text, !searchText.isEmpty {
            ApiClient.apiClient.search(params: searchText) { response in
                self.searchList = response.articles
                self.searchTableView.reloadData()
            }
        }
        searchBar.resignFirstResponder() // Klavyeyi kapat
    }
    
    // Arama işlemini gerçekleştiren fonksiyonu çağırın
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("semaaa:\(searchText)")
        filteredArticles = searchArticles(with: searchText)
        searchTableView.reloadData()
    }
    
    func searchArticles(with searchText: String) -> [Article] {
        // Arama metnine göre filtreleme işlemini gerçekleştirin ve sonuçları döndürün
        if searchText.isEmpty {
            getSearhList()
            return searchList!
        } else {
            let filteredArticles = searchList!.filter { $0.title!.contains(searchText) }
            print("eda:\(searchText)")
            return filteredArticles
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if let searchIconImageView = searchBar.searchTextField.leftView as? UIImageView {
            searchIconImageView.tintColor = hexStringToUIColor(hex: "#FFa500")
            }
            // Search bar'a tıklandığında border rengini ayarla
           // searchBar.layer.borderColor = UIColor.red.cgColor
           // searchBar.layer.borderWidth = 1.0
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            // Search bar'dan başka bir yere tıklandığında border'ı kaldır
           // searchBar.layer.borderWidth = 0.0
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // İşlem yapmak istediğiniz kodu buraya yazın
        print("Cancel butonuna tıklandı!")
        
        // Arama çubuğunu temizlemek için
        searchBar.text = ""
        
        // Klavyeyi kapatmak için
        searchBar.resignFirstResponder()
        
    }
}
