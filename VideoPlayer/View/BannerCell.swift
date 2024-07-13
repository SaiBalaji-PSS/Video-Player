//
//  BannerCell.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import UIKit

protocol BannerCellDelegate: AnyObject{
    func bannerCollectionViewCellClicked(movieData: Movie)
}

class BannerCell: UITableViewCell {
    weak var delegate: BannerCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var movies = [Movie]()
    var tableViewIndex = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CELL")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true 
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false 
    }

   
    
    func updateCell(movies: [Movie]){
        self.movies = movies
        self.collectionView.reloadData()
    }
    
    
}


extension BannerCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? BannerCollectionViewCell{
            cell.updateCell(url: self.movies[indexPath.row].thumb)
            if tableViewIndex.section != 0{
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 0.5
                cell.layer.cornerRadius = 4
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.bannerCollectionViewCellClicked(movieData: self.movies[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if tableViewIndex.section == 0{
               let size = collectionView.frame.size
               return CGSize(width: size.width, height: size.height)
           }
           return CGSize(width: 150, height: 200)
           
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10.0
       }
    
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0.0
       }
    
}
