//
//  PicTableViewCell.swift
//  PicViewer
//
//  Created by Penchal on 11/08/20.
//  Copyright © 2020 senix.com. All rights reserved.
//

import UIKit

class PicTableViewCell: UITableViewCell {

    @IBOutlet weak var tableCellPiture:UIImageView!
    @IBOutlet weak var picID:UILabel!
    @IBOutlet weak var authorName:UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
