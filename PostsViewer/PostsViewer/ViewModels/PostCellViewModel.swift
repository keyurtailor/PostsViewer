//
//  PostCellViewModel.swift
//  PostsViewer
//
//  Created by keyur.tailor on 26/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import Foundation


struct PostCellViewModel {
    
    let mainTitleText: String
    let detailText: String
    let isFavourite: Bool
    
    init(post: PostDetail) {
        self.mainTitleText = post.title ?? ""
        self.detailText = post.body ?? ""
        self.isFavourite = post.favourite
    }
}
