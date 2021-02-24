//
//  PostCell.swift
//  PostsViewer
//
//  Created by keyur.tailor on 24/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
