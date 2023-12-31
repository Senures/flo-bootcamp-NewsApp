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
    let label = UILabel()
    
    let categoryList = ["Business","Entertainment","General","Health","Science","Sports","Technology"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "No search results found"
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.sizeToFit()
        
        
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        label.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        label.isHidden = true
        view.addSubview(label)
        
        categoryCv.delegate = self
        categoryCv.dataSource = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.reloadData()
        searchBar.barTintColor = UIColor.black
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.tintColor = UIColor.black
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchBar.delegate = self
      
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        categoryCv.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getSearhList()
        
        
    }
    
    func getSearhList(){
        showActivityIndicator()
        
        ApiClient.apiClient.search(params:"business") { response in
            
            self.searchList = response.articles
            self.hideActivityIndicator()
            self.searchTableView.reloadData()
            
        }
        
    }
    
}

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
            cell.img.kf.setImage(with: URL(string:searchList?[indexPath.row].urlToImage ??  Constants.emptyUrlImage), placeholder:UIImage(named:"image"))
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
        
        if indexPath.row == 0 {
            cell.categoryName.text = categoryList[0]
            cell.categoryName.textColor = .systemOrange
            cell.categoryName.font = UIFont.systemFont(ofSize: 16)
            cell.contentView.layer.borderWidth = 1.0 // Kenarlık kalınlığını belirleyin
            cell.contentView.layer.borderColor = UIColor.systemOrange.cgColor
            cell.contentView.layer.cornerRadius = 10
        }else{
            cell.categoryName.text = categoryList[indexPath.row]
            cell.categoryName.font = UIFont.systemFont(ofSize: 16)
            cell.categoryName.textColor = .white
            cell.contentView.layer.masksToBounds = true
        }
        
        return cell
    }
    
    //tıkladındıgında o indekste hangisi var bu bir yatayda kayan collectionview
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else {
            return
        }
        
        //tıklanılan hücrelerin görünümü
        cell.categoryName.textColor = .systemOrange
        cell.categoryName.font = UIFont.systemFont(ofSize: 16)
        cell.contentView.layer.borderWidth = 1.0 // Kenarlık kalınlığını belirleyin
        cell.contentView.layer.borderColor = UIColor.systemOrange.cgColor
        cell.contentView.layer.cornerRadius = 10
        
        
        //business general gibi yerlere basınca calısan api
        showActivityIndicator()
        ApiClient.apiClient.search(params:categoryList[indexPath.row]) { response in
            self.searchList = response.articles
            self.hideActivityIndicator()
            self.searchTableView.reloadData()
            
        }
        
        //tıklanılmayan hücrelerin görünümü
        for visibleCell in collectionView.visibleCells {
            if let otherCell = visibleCell as? CategoryViewCell, otherCell != cell {
                otherCell.categoryName.font = UIFont.systemFont(ofSize: 15)
                otherCell.contentView.layer.borderWidth = 0.0 // Kenarlık kalınlığını sıfıra ayarlayın
                otherCell.categoryName.textColor = .white
                
                
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Arama işlemini gerçekleştirin
        if let searchText = searchBar.text, !searchText.isEmpty {
            showActivityIndicator()
            ApiClient.apiClient.search(params: searchText) { response in
                self.searchList = response.articles
                self.hideActivityIndicator()
                self.searchTableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            showActivityIndicator()
            ApiClient.apiClient.search(params: searchText) { response in
                self.searchList = response.articles
                self.hideActivityIndicator()
                if self.searchList?.count == 0 {
                    
                    self.searchTableView.isHidden = true
                    self.label.isHidden = false
                }else{
                    self.searchTableView.isHidden = false
                    self.label.isHidden = true
                    
                }
                self.searchTableView.reloadData()
            }
        }
        filteredArticles = searchArticles(with: searchText)
        searchTableView.reloadData()
    }
    
    func searchArticles(with searchText: String) -> [Article] {
        
        if searchText.isEmpty {
            label.isHidden = true
            searchTableView.isHidden = false
            getSearhList()
            return searchList!
        } else {
            let filteredArticles = searchList?.filter { $0.title!.contains(searchText) }
            
            return filteredArticles ?? []
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if let searchIconImageView = searchBar.searchTextField.leftView as? UIImageView {
            searchIconImageView.tintColor = hexStringToUIColor(hex: "#FFa500")
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Arama çubuğunu temizlemek için
        searchBar.text = ""
        // Klavyeyi kapatmak için
        searchBar.resignFirstResponder()
        
    }
}
