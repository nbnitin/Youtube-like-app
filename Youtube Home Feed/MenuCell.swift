//
//  MenuCell.swift
//  Youtube Home Feed
//
//  Created by Nitin on 15/01/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    
    override var isHighlighted: Bool {
        didSet {
            imgIconMenu.tintColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imgIconMenu.tintColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
    @IBOutlet weak var imgIconMenu: UIImageView!
    
}
