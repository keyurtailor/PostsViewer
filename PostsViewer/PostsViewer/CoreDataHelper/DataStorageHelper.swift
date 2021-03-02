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
    
    func fetchAllPostsFromCoreData() -> [PostDetail] {
        let listOfCoreDataPosts = BehaviorRelay(value: [PostDetail]())
        
        listOfCoreDataPosts.accept([PostDetail]())
        listOfCoreDataPosts.accept(PersistenceService.shared.fetch(PostDetail.self))
        
        return listOfCoreDataPosts.value
    }
    
    func fetchFavouritePostsFromCoreData() -> [PostDetail] {
        let listOfCoreDataFavouritePosts = BehaviorRelay(value: [PostDetail]())
        
        let posts = PersistenceService.shared.fetch(PostDetail.self)
        let favPosts = posts.filter { $0.favourite }
        
        listOfCoreDataFavouritePosts.accept([PostDetail]())
        listOfCoreDataFavouritePosts.accept(favPosts)
        
        return listOfCoreDataFavouritePosts.value
    }
    
    func markFavouritePost(indexPath: Event<IndexPath>, listType: PostListType, data: BehaviorRelay<[PostDetail]>) {
        switch indexPath {
        case .next(let value):
            data.value[value.row].favourite = !data.value[value.row].favourite
            PersistenceService.shared.saveContext()
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
