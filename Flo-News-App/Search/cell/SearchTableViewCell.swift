//
//  SearchTableViewCell.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 27.06.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var img: UIImageView! {
        
        didSet {
            img.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var dscriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     
    }

  

}
