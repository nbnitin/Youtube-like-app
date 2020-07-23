//
//  ViewController.swift
//  Youtube Home Feed
//
//  Created by Nitin on 15/01/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
     let lblNavTitle = UILabel()

    @IBOutlet weak var feedCollView: UICollectionView!
    
    @IBOutlet weak var menuView: MenuBar!
    @IBOutlet weak var menuCollView: UICollectionView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        lblNavTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: self.view.frame.height)
        lblNavTitle.text = "Home"
        lblNavTitle.font = UIFont.systemFont(ofSize: 20)
        lblNavTitle.textColor = .white
        navigationItem.titleView = lblNavTitle
        
        menuCollView.delegate = menuView
        menuCollView.dataSource = menuView
        let firstSelectedIndexPath = IndexPath(item: 0, section: 0)
        menuCollView.selectItem(at: firstSelectedIndexPath, animated: false, scrollPosition:.init())
        
        //navigationController?.hidesBarsOnSwipe = true
        
        feedCollView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)
        feedCollView.scrollIndicatorInsets = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)
       // menuCollView.topAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuView.setupLowerBar()
        menuView.homeVC = self
        
        
    }
    
    func scrollToIndexPath(indexPath:IndexPath) {
        if ( indexPath.row == 0 ) {
          lblNavTitle.text = "Home"
        } else if ( indexPath.row == 1 ) {
          lblNavTitle.text = "Trending"
        } else if ( indexPath.row == 2 ) {
          lblNavTitle.text = "Downloads"
        } else {
          lblNavTitle.text = "Account"
        }
        
        feedCollView.scrollToItem(at: indexPath, at: .init(), animated: true)
    }

    
    //collection view
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if ( indexPath.row == 1 ) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trending", for: indexPath) as! trendingCell
            cell.setupCollView(vc:self)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFeed", for: indexPath) as! feedCell
        
        cell.setupCollView(vc:self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.view.frame.height - 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuView.leftAnchorForBottomBar?.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //chaging memory constat to index
        let x = (targetContentOffset.move().x / view.frame.width)
        let firstSelectedIndexPath = IndexPath(item: Int(x), section: 0)
        menuCollView.selectItem(at: firstSelectedIndexPath, animated: false, scrollPosition:.init())
        self.scrollToIndexPath(indexPath: firstSelectedIndexPath)
       // menu.selectItem(at: index, animated: true, scrollPosition: .init())
    }
    
    
    
}

