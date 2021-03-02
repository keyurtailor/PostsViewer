//
//  PostsDisplayViewModel.swift
//  PostsViewer
//
//  Created by keyur.tailor on 22/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AllPostsDisplayViewModel {
    
    let dataStorage = DataStorageHelper.shared
    let persistenceManager = PersistenceService.shared
    var disposeBag = DisposeBag()
    
    var listOfPosts = BehaviorRelay(value: [PostDetail]())
    
    init() {
        
    }
    
    func fetchDataFromAPI() {
        WebserviceHelper.shared.getPostsList(successCallback: { (posts) in
            let _ = posts.map { DataStorageHelper.shared.savePostToCoreData(postObj: $0) }
            self.listOfPosts.accept(self.dataStorage.fetchAllPostsFromCoreData())
        }) { (failureDict) in
            self.listOfPosts.accept(self.dataStorage.fetchAllPostsFromCoreData())
            print(failureDict)
        }
    }
    
    func getPosts() {
        self.listOfPosts.accept(dataStorage.fetchAllPostsFromCoreData())
    }
    
    func getFavouritePosts() {
        self.listOfPosts.accept(dataStorage.fetchFavouritePostsFromCoreData())
    }
    
    func markFavouritePost(indexPath: Event<IndexPath>, listType: PostListType) {
        dataStorage.markFavouritePost(indexPath: indexPath, listType: listType, data: self.listOfPosts)
        listType == PostListType.AllPosts ? self.listOfPosts.accept(dataStorage.fetchAllPostsFromCoreData()) : self.listOfPosts.accept(dataStorage.fetchFavouritePostsFromCoreData())
    }
    
}
