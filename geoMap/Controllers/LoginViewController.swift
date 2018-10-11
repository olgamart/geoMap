//
//  LoginViewController.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButtonOut: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var router: LoginRouter!
    private let disposeBag = DisposeBag()
    var newUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = newUser {
            loginTextField.text = user.login
            passwordTextField.text = user.password
            configureLoginBindings()
        }
    }
    
    
    @IBAction func authButton(_ sender: Any) {
        router.toAuth()
    }
    @IBAction func loginButton(_ sender: Any) {
        
        guard let login = loginTextField.text,
            let password = passwordTextField.text else {return}
        DispatchQueue.global().async {
            if let user = RealmService.findUser(type: User.self, userLogin: login) as? User {
                if(user.login == login && user.password == password) {
                    DispatchQueue.main.async {
                        self.newUser = nil
                        self.router.toMap()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showPasswordError()
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showLoginError()
                }
            }
        }
    }
    
    private func showPasswordError() {
        let alter = UIAlertController(title: "Ошибка", message: "Неверный пароль", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    private func showLoginError() {
        let alter = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    private func configureLoginBindings(){
        Observable
          .combineLatest(
            loginTextField.rx.text,
             passwordTextField.rx.text
        )
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 4
            }
        .bind(to: loginButtonOut.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}
