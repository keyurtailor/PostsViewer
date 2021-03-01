//
//  DataStorageHelper.swift
//  PostsViewer
//
//  Created by keyur.tailor on 26/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum PostListType {
    case AllPosts
    case FavouritePosts
}

final class DataStorageHelper {
    
    private init() { }
    
    static let shared = DataStorageHelper()
    
    var listOfPosts = BehaviorRelay(value: [PostDetail]())
    
    func fetchAllPostsFromCoreData() {
        self.listOfPosts.accept([PostDetail]())
        self.listOfPosts.accept(PersistenceService.shared.fetch(PostDetail.self))
    }
    
    func fetchFavouritePostsFromCoreData() {
        let posts = PersistenceService.shared.fetch(PostDetail.self)
        let favPosts = posts.filter { $0.favourite }
        
        self.listOfPosts.accept([PostDetail]())
        self.listOfPosts.accept(favPosts)
    }
    
    func markFavouritePost(indexPath: Event<IndexPath>, listType: PostListType) {
        switch indexPath {
        case .next(let value):
            self.listOfPosts.value[value.row].favourite = !self.listOfPosts.value[value.row].favourite
            PersistenceService.shared.saveContext()
            self.fetchAllPostsFromCoreData()
            listType == PostListType.AllPosts ? self.fetchAllPostsFromCoreData() : self.fetchFavouritePostsFromCoreData()
        case .error(let error):
            print(error.localizedDescription)
        case .completed:
            print("Completed")
        }
    }
    
    func savePostToCoreData(postObj: Post) {
        if (!PersistenceService.shared.isEntityAttributeExist(id: postObj.id, entityName: "PostDetail")) {
            let post = PostDetail(context: PersistenceService.shared.context)
            post.id = Int16(postObj.id)
            post.userId = Int16(postObj.userId)
            post.title = postObj.title
            post.body = postObj.body
            post.favourite = false
            PersistenceService.shared.saveContext()
        }
    }
}
