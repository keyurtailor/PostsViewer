//
//  PostsDisplayVC.swift
//  PostsViewer
//
//  Created by keyur.tailor on 22/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import UIKit

class PostsDisplayVC: UIViewController {

    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabbar.selectedItem = tabbar.items?.first!
        
        WebserviceHelper.shared.getPostsList(successCallback: { (successDict) in
            print(successDict)
        }) { (failureDict) in
            print(failureDict)
        }
    }
    
}

extension PostsDisplayVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
    }
}
