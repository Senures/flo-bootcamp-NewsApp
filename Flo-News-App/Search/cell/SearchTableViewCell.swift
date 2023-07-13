//
//  SearchTableViewCell.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 27.06.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    /*  var contentInsets: UIEdgeInsets = .zero {
           didSet {
               setNeedsLayout() // Layout yenileme isteği gönder
           }
       }

       override func layoutSubviews() {
           super.layoutSubviews()

           // Hücre içeriğinin (contentView) kenar boşluklarını ayarla
           contentView.frame = contentView.frame.inset(by: contentInsets)
       }*/

    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var img: UIImageView! {
        
        didSet {
            img.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var dscriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // SkeletonView ayarları
       // contentView.isSkeletonable = true
       // contentView.showAnimatedSkeleton()
     
    }

  

}
