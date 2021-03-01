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
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    var cellViewModel: PostCellViewModel! {
        didSet {
            self.mainTitle.text = cellViewModel.mainTitleText
            self.detailTitle.text = cellViewModel.detailText
            if let imageView = self.favouriteImageView {
                imageView.isHidden = false
                imageView.image = cellViewModel.isFavourite ? UIImage(named: "FavouritesIcon") : UIImage(named: "NonFavouriteIcon")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        self.contentView.layer.borderWidth = 10
        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        self.selectionStyle = .none
    }

}
