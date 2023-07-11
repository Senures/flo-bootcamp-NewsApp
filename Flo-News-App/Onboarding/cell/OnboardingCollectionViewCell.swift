//
//  OnboardingCollectionViewCell.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 13.06.2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var slideImage: UIImageView!
    
    @IBOutlet weak var slideTitle: UILabel!
    // @IBOutlet weak var slideTitle: UILabel!
    
    
    @IBOutlet weak var slideDescription: UILabel!
    //  @IBOutlet weak var slideDescription: UILabel!
    
    func setUp (_ slide : OnboardingModel){
        slideImage.layer.cornerRadius = 10
        slideImage.image = slide.image
        slideTitle.text = slide.title
        slideDescription.text = slide.descriptiom
    }
}
