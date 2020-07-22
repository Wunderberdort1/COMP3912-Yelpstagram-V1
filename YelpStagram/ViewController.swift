//
//  ViewController.swift
//  YelpStagram
//
//   .
//  Copyright © 2020 Sam Meech-Ward. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let networkManager = NetworkManager()
    var places: [Place] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let term = "Cafe"
    networkManager.getPlaces(term: term) { [weak self] places, error in
      if let error = error {
        print("Error getting places \(error)")
        return
      }
      guard let places = places else {
        print("Error getting places")
        return
      }

      self?.places = places
      print(places)
        
       // reload the collection view
       // self?.collectionView.reloadData()
        

    }
        
    collectionView?.collectionViewLayout = layout()
  }
    
    func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize (
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(450)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize (
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(450)
            )
            
            let columns = environment.container.contentSize.width > 500 ? 2: 1
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            group.interItemSpacing = .fixed(20)
            
            if columns > 1 {
                group.contentInsets.leading = 20
                group.contentInsets.trailing = 20
            }
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 20
            section.contentInsets.top = 20
            
            return section
        }
        
        return layout
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YelpStagramCollectionViewCell
        var imageViews: [UIImageView] = []
        cell.delegate = self
        
        if self.places.count == 0 {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.places.count == 0 {
            } else {

                cell.thumbnailImage.image = self.places[indexPath.item].mainImage
                cell.nameOfBusiness.text = self.places[indexPath.item].name
                cell.priceLabel.text = self.places[indexPath.item].price
                cell.ratingLabel.text = "Rating: " + String(self.places[indexPath.item].rating) + "/5"
                if self.places[indexPath.item].is_closed {
                    cell.openclosedLabel.text = "Open"
                } else {
                    cell.openclosedLabel.text = "Closed"
                }
                
                
                self.places[indexPath.item].images?.forEach{ image in
                    imageViews.append(UIImageView(image: image))
                }
                
                if cell.imagesStackView.arrangedSubviews.count == 0 {
                imageViews.forEach { imageView in
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    
                    cell.imagesStackView.addArrangedSubview(imageView)
                    
                    }}
                
                NSLayoutConstraint.activate([cell.imagesStackView.heightAnchor.constraint(equalTo: cell.imagesScrollView.frameLayoutGuide.heightAnchor),
                     cell.imagesStackView.widthAnchor.constraint(equalTo: cell.imagesScrollView.frameLayoutGuide.widthAnchor, multiplier: CGFloat(imageViews.count))])
                
                timer.invalidate()
                
            }
            
        }
            return cell
        } else {
            cell.thumbnailImage.image = self.places[indexPath.item].mainImage
            cell.nameOfBusiness.text = self.places[indexPath.item].name
            cell.priceLabel.text = self.places[indexPath.item].price
            cell.ratingLabel.text = "Rating: " + String(self.places[indexPath.item].rating) + "/5"
            if self.places[indexPath.item].is_closed {
                cell.openclosedLabel.text = "Open"
            } else {
                cell.openclosedLabel.text = "Closed"
            }
            
            self.places[indexPath.item].images?.forEach{ image in
                imageViews.append(UIImageView(image: image))
            }
            
            if cell.imagesStackView.arrangedSubviews.count == 0 {
            imageViews.forEach { imageView in
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                
                cell.imagesStackView.addArrangedSubview(imageView)
                
                }}
            
            NSLayoutConstraint.activate([cell.imagesStackView.heightAnchor.constraint(equalTo: cell.imagesScrollView.frameLayoutGuide.heightAnchor),
                 cell.imagesStackView.widthAnchor.constraint(equalTo: cell.imagesScrollView.frameLayoutGuide.widthAnchor, multiplier: CGFloat(imageViews.count))])
            return cell
        }
        


    }
    
}

extension ViewController: YelpStagramCollectionViewCellDelegate {
    func yelpStagramCollectionViewCell(_ vc: YelpStagramCollectionViewCell, image: UIView) {
        guard let vc = storyboard?.instantiateViewController(identifier: "SPViewController") as? ScrollablePicViewController else {
            return
        }
        vc.set(image: image as! UIImageView)
        present(vc, animated: true, completion: nil)
    }
}

