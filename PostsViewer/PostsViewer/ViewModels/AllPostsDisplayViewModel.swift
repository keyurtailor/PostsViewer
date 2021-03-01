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
    
    init() {
        
    }
    
    func fetchDataFromAPI() {
        WebserviceHelper.shared.getPostsList(successCallback: { (posts) in
            let _ = posts.map { DataStorageHelper.shared.savePostToCoreData(postObj: $0) }
            self.dataStorage.fetchAllPostsFromCoreData()
        }) { (failureDict) in
            self.dataStorage.fetchAllPostsFromCoreData()
            print(failureDict)
        }
    }
    
    func getPosts() {
        dataStorage.fetchAllPostsFromCoreData()
    }
    
    func getFavouritePosts() {
        dataStorage.fetchFavouritePostsFromCoreData()
    }
    
}
