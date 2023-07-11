//
//  TrendCollectionViewCell.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 26.06.2023.
//

import UIKit

class TrendCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
  
    @IBOutlet weak var lbl: UILabel!
    //  @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sourceLbl: UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           
           // UIImageView'in contentMode özelliğini ayarla
       // img.contentMode = .scaleAspectFit
       }
    
}
