//
//  FavouritePostsDisplayVC.swift
//  PostsViewer
//
//  Created by keyur.tailor on 26/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavouritePostsDisplayVC: UIViewController {

    @IBOutlet weak var favouritePostsTable: UITableView!
    
    var viewModel: AllPostsDisplayViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = AllPostsDisplayViewModel()
        
        self.setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getFavouritePosts()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = "Favourite"
    }
    
    func setupTable() {
        viewModel.listOfPosts
            .observeOn(MainScheduler.instance)
            .bind(to: favouritePostsTable.rx.items) { (tableView, index, post) -> UITableViewCell in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath.init(row: index, section: 0)) as! PostCell
                cell.cellViewModel = PostCellViewModel(post: post)
                return cell
                
            }.disposed(by: disposeBag)
        
        favouritePostsTable.rx.itemSelected
            .subscribe({ [weak self] indexPath in
                self?.viewModel.markFavouritePost(indexPath: indexPath, listType: .FavouritePosts)
            }).disposed(by: disposeBag)
    }

}
