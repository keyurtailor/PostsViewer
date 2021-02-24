//
//  PostsDisplayVC.swift
//  PostsViewer
//
//  Created by keyur.tailor on 22/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostsDisplayVC: UIViewController {

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var postsTableView: UITableView!
    
    let persistenceManager = PersistenceService.shared
    var disposeBag = DisposeBag()
    
    var listOfPosts: [PostDetail]! = [PostDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabbar.selectedItem = tabbar.items?.first!
        
        WebserviceHelper.shared.getPostsList(successCallback: { [weak self] (posts) in
            let _ = posts.map { self?.savePostToCoreData(postObj: $0) }
            self?.fetchAllPostsFromCoreData()
        }) { [weak self] (failureDict) in
            self?.fetchAllPostsFromCoreData()
            print(failureDict)
        }
    }
    
    func savePostToCoreData(postObj: Post) {
        let post = PostDetail(context: persistenceManager.context)
        post.id = Int16(postObj.id)
        post.userId = Int16(postObj.userId)
        post.title = postObj.title
        post.body = postObj.body
        post.favourite = false
        persistenceManager.saveContext()
    }
    
    func fetchAllPostsFromCoreData() {
        self.listOfPosts = [PostDetail]()
        self.listOfPosts = persistenceManager.fetch(PostDetail.self)
        let tableData : Observable<[PostDetail]> = Observable.just(self.listOfPosts)
        self.setupTableWith(data: tableData)
    }
    
    func fetchFavouritePostsFromCoreData() {
        let posts = persistenceManager.fetch(PostDetail.self)
        self.listOfPosts = [PostDetail]()
        _ = posts.map { [weak self] in
            if $0.favourite {
                self?.listOfPosts.append($0)
            }
        }
        let tableData : Observable<[PostDetail]> = Observable.just(self.listOfPosts)
        self.setupTableWith(data: tableData)
    }
    
    func markFavouritePost(indexPath: IndexPath) {
        self.listOfPosts?[indexPath.row].favourite = !self.listOfPosts[indexPath.row].favourite
        self.persistenceManager.saveContext()
        if tabbar.selectedItem == (tabbar.items)?[0] {
            print("Posts Selected")
            self.fetchAllPostsFromCoreData()
        }
        else if tabbar.selectedItem == (tabbar.items)?[1] {
            print("Favourites Selected")
            self.fetchFavouritePostsFromCoreData()
        }
    }
    
    func setupTableWith(data: Observable<[PostDetail]>) {
        self.disposeBag = DisposeBag()
        data.bind(to: postsTableView.rx.items(cellIdentifier: "cell")) { _, post, cell in
            guard let cellToUse = cell as? PostCell else { return }
            cellToUse.mainTitle?.text = post.title
            cellToUse.detailTitle?.text = post.body
        }.disposed(by: disposeBag)
        
        postsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
            self?.markFavouritePost(indexPath: indexPath)
        }).disposed(by: disposeBag)
    }
}

extension PostsDisplayVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (tabBar.items)?[0] {
            print("Posts Selected")
            self.fetchAllPostsFromCoreData()
        }
        else if item == (tabBar.items)?[1] {
            print("Favourites Selected")
            self.fetchFavouritePostsFromCoreData()
        }
    }
}
