//
//  LoginViewController.swift
//  Quest_game
//
//  Created by Admin on 09.05.2021.
//

import Foundation
import UIKit

class LoginViewController : UIViewController
{
    

    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CreateNewAccountButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    var user : User!
    override func viewDidLoad() {
        
        //self.navigateToMenu()
        
        Client.instance.OnCreateUserResultRecieved = {(exist:Bool, id: Int) in
            if exist {
                self.LoginTextField.backgroundColor = UIColor.green;
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.LoginTextField.backgroundColor = UIColor.red;
            }
            else{
               
                Client.instance.requestUser(id: id)
            }
        }
        Client.instance.OnUserRecieved = {(user : User) in
            GameManager.user = user
            self.navigateToMenu()
            Client.instance.requestTopics(count: GameManager.topicsCount)
            
        }
        Client.instance.OnConfirmationRecieved = { (passwordValid:Bool,id:Int) in
            if passwordValid{
                Client.instance.requestUser(id: id)
            }
            else{
                let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    
            }
            
        }
    }
    @IBAction func CreateNewAccountButtonPressed(_ sender: Any) {
       
        let username = LoginTextField.text
        let password = PasswordTextField.text
        if username?.count == 0 || password?.count == 0 {
            let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if password!.count > 8 {
            // create the alert
                  let alert = UIAlertController(title: "Ошибка", message: "Пароль может содержать максимум 8 символов", preferredStyle: UIAlertController.Style.alert)
                  alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
            return
        }
        user = User(id: -1, userName: username!, score: 0)
        Client.instance.requestCreateUser(userName: username!, password: password!)
    }
    @IBAction func SignInButtonPressed(_ sender: Any) {
        let username = LoginTextField.text
        let password = PasswordTextField.text
        if username?.count == 0 || password?.count == 0 {
            let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        Client.instance.requestPasswordValidation(userName: username!, password: password!)
        
    }
    

    

    func navigateToMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let questionsChoosingVC = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.present(questionsChoosingVC, animated: true, completion: nil)
    }
}
