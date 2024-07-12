//
//  MovieCell.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 12/07/24.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateCell(imageURL: String){
        self.posterImageView.sd_setImage(with: URL(string: imageURL))
    }

}
