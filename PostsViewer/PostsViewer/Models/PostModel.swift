//
//  PostModel.swift
//  PostsViewer
//
//  Created by keyur.tailor on 23/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
