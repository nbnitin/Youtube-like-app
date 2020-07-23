//
//  MenuBar.swift
//  Youtube Home Feed
//
//  Created by Nitin on 15/01/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit

class MenuBar : UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
   let imageNames = ["home","flame","download","user"]
   @IBOutlet weak var horizontalBar: UIView!
    
    var leftAnchorForBottomBar : NSLayoutConstraint?
    var homeVC : ViewController!
    
    func setupLowerBar(){
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
       leftAnchorForBottomBar = horizontalBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        leftAnchorForBottomBar?.isActive = true
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
        cell.imgIconMenu.image = UIImage(named: imageNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4 - 0.3, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat(indexPath.row) * frame.width / 4
        self.leftAnchorForBottomBar?.constant = x
        homeVC.scrollToIndexPath(indexPath:indexPath)
       
      // commeting below code  because now view controller now keeps track of bottom bar
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        
        
    }
}
