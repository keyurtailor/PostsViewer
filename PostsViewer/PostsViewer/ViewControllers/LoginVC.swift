//
//  LoginVC.swift
//  PostsViewer
//
//  Created by keyur.tailor on 22/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let loginVM = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.becomeFirstResponder()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setObservables()
    }
    
    private func setObservables() {
        emailTextfield.rx.text
            .map { $0 ?? "" }
            .bind(to: loginVM.emailText)
            .disposed(by: disposeBag)
        
        passwordTextfield.rx.text
            .map { $0 ?? "" }
            .bind(to: loginVM.passwordText)
            .disposed(by: disposeBag)
        
        loginVM.isValid()
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginVM.isValid()
            .map{ $0 ? 1 : 0.3 }
            .bind(to: submitButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    @IBAction func submitButtonTapped(_ sender : UIButton) {
        performSegue(withIdentifier: "ShowPostsDisplayVC", sender: self)
    }

}
