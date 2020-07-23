//
//  VideoCell.swift
//  Youtube Home Feed
//
//  Created by Nitin on 15/01/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgChannel: UIImageView!
    @IBOutlet weak var imgThumbnail: UIImageView!
        
   
    
    override func layoutSubviews() {
        setupViews()
    }
    
    func setupViews() {
        imgChannel.clipsToBounds = true
        imgChannel.layer.cornerRadius = imgChannel.frame.size.width / 2
        
        
        lblDescription.text = "This movie star cast of bruce lee."
    }
    
}
