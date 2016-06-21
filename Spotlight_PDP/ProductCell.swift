//
//  ProductCell.swift
//  Spotlight_PDP
//
//  Created by Aynur Galiev on 21.06.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productImageView.layer.cornerRadius = 4
        self.productImageView.layer.borderWidth = 1
        self.productImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

}
