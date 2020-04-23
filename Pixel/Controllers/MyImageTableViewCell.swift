//
//  MyImageTableViewCell.swift
//  Pixel
//
//  Created by Anna Zislina on 16/04/2020.
//  Copyright © 2020 Anna Zislina. All rights reserved.
//

import UIKit

class MyImageTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
