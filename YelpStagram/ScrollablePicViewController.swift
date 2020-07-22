//
//  ScrollablePicViewController.swift
//  YelpStagram
//
//  Created by Justin Tan on 2020-05-22.
//  Copyright © 2020 Sam Meech-Ward. All rights reserved.
//

import UIKit

class ScrollablePicViewController: ViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    

    @IBOutlet weak var imageView: UIImageView!
    

    var image: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image?.image
        
        NSLayoutConstraint.activate([
        imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
        imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        
        scrollView.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.minimumZoomScale = scrollView.frame.width/(imageView.image!.size.width)
    }

    func set(image: UIImageView) {
        self.image = image
    }
}

extension ScrollablePicViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
