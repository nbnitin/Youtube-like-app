//
//  trendingCell.swift
//  Youtube Home Feed
//
//  Created by Nitin on 16/01/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit



class trendingCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var innerCollView: UICollectionView!
     var homeVC: ViewController!
       
    func setupCollView(vc:ViewController){
        innerCollView.delegate = self
        innerCollView.dataSource = self
        homeVC = vc
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 10
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           
           
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
           cell.backgroundColor = .red
           cell.lblTitle.text = "trending cell"
           return cell
       }
       
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: self.frame.width, height: 300)
       }
       
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 5
       }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if ( innerCollView.contentOffset.y > 10 ) {
               homeVC!.navigationController?.setNavigationBarHidden(true, animated: true)
           } else {
               homeVC!.navigationController?.setNavigationBarHidden(false, animated: true)
           }
           
       }
       
}
