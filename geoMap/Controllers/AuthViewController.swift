//
//  AuthViewController.swift
//  geoMap
//
//  Created by Olga Martyanova on 24/09/2018.
//  Copyright © 2018 olgamart. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet var router: AuthRouter!
    @IBOutlet weak var loginTextField: UITextField!    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func authButton(_ sender: Any) {
        guard let login = loginTextField.text,
            let password = passwordTextField.text else {return}
        if (login.isEmpty || password.count < 4) {
            showAuthError()
        } else {
            DispatchQueue.global().async {
                if let user = RealmService.findUser(type: User.self, userLogin: login) as? User {
                    RealmService.setPassword(saveObject: user, savePassword: password)
                    DispatchQueue.main.async {
                        self.showMessage(newUser: User(login: login, password: password))                        
                    }
                    
                } else {                    
                    RealmService.saveUser(saveObject: User(login: login, password: password))
                    DispatchQueue.main.async {
                        self.showMessage(newUser: User(login: login, password: password))
                    }                   
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        router.toLogin(controller: self, user: User())
    }
    private func showAuthError() {
        let alter = UIAlertController(title: "Ошибка", message: "Введены неверные данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    private func showMessage(newUser: User) {
        let alter = UIAlertController(title: "Успешная регистрация", message: "Ваш логин: \(newUser.login)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler:{ [weak self] action in
            if let controller = self {
            controller.router.toLogin(controller: controller, user: newUser)
            }
            }
        )
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
}
