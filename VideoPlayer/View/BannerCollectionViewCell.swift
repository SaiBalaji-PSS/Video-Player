//
//  BannerCollectionViewCell.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import UIKit
import SDWebImage


class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func updateCell(url: String){
        self.bannerImageView.contentMode = .scaleAspectFill
        self.bannerImageView.sd_setImage(with: URL(string: url)!)
        
    }

}
