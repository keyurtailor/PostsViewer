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

    @IBOutlet weak var postsTableView: UITableView!
    
    var viewModel: AllPostsDisplayViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AllPostsDisplayViewModel()
        viewModel.fetchDataFromAPI()
        
        self.setupTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getPosts()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "Posts"
    }
    
    func setupTable() {
        viewModel.listOfPosts
            .observeOn(MainScheduler.instance)
            .bind(to: postsTableView.rx.items) { (tableView, index, post) -> UITableViewCell in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath.init(row: index, section: 0)) as! PostCell
                cell.cellViewModel = PostCellViewModel(post: post)
                return cell
                
            }.disposed(by: disposeBag)
        
        postsTableView.rx.itemSelected
            .subscribe({ [weak self] indexPath in
                self?.viewModel.markFavouritePost(indexPath: indexPath, listType: .AllPosts)
            }).disposed(by: disposeBag)
    }
    
}
