//
//  HeadTableViewCell.swift
//  zhihuNews
//
//  Created by Nirvana on 8/19/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import PagedHorizontalView

class HeadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pageView: LocalPagedHorizontalView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
