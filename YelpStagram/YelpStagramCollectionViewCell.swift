//
//  YelpStagramCollectionViewCell.swift
//  YelpStagram
//
//  Created by Justin Tan on 2020-05-21.
//  Copyright © 2020 Sam Meech-Ward. All rights reserved.
//

import UIKit

protocol YelpStagramCollectionViewCellDelegate: AnyObject {
    func yelpStagramCollectionViewCell(_ vc: YelpStagramCollectionViewCell, image: UIView)
}

class YelpStagramCollectionViewCell: UICollectionViewCell {
    
    var scrollViewPage: Int = 0
    
    weak var delegate: YelpStagramCollectionViewCellDelegate?
    
    @IBOutlet weak var nameOfBusiness: UILabel!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    @IBOutlet weak var openclosedLabel: UILabel!
    
    
    @IBOutlet weak var imagesScrollView: UIScrollView! {didSet {   setup()
    } }
     
    @IBOutlet var imagesStackView: UIStackView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    @IBAction func changePage(_ pageControl: UIPageControl) {
        let offset = CGFloat(pageControl.currentPage) * imagesScrollView.frame.width
        imagesScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    func setup() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imagesScrollView.addGestureRecognizer(tapGesture)
            }
    
    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        var newImage = UIImageView()
        newImage = imagesStackView.arrangedSubviews[self.scrollViewPage] as! UIImageView
        self.delegate?.yelpStagramCollectionViewCell(self, image:  newImage)
    }
    
}

extension YelpStagramCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        pageControl.currentPage = page
        scrollViewPage = page

    }

} 
