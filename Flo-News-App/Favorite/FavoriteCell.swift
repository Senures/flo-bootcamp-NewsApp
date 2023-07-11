//
//  FavoriteCell.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 2.07.2023.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!{
        
        didSet {
            img.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
