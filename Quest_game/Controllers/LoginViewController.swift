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
        
        Client.instance.OnTopicsRecieved = {(topics:[String]) in
            GameManager.topics = topics
            print(topics)
            self.navigateToQuestionChoosing()
            
        }
        Client.instance.OnCreateUserResultRecieved = {(exist:Bool, id: Int) in
            if exist {
                self.LoginTextField.backgroundColor = UIColor.red;
            }
            else{
                self.LoginTextField.backgroundColor = UIColor.green;
                Client.instance.requestUser(id: id)
            }
        }
        Client.instance.OnUserRecieved = {(user : User) in
            GameManager.user = user
            
            Client.instance.requestTopics(count: GameManager.topicsCount)
            
        }
        Client.instance.OnConfirmationRecieved = { (passwordValid:Bool,id:Int) in
            if passwordValid{
                Client.instance.requestUser(id: id)
            }
            
        }
    }
    @IBAction func CreateNewAccountButtonPressed(_ sender: Any) {
       
        let username = LoginTextField.text
        let password = PasswordTextField.text
        user = User(id: -1, userName: username!, score: 0)
        Client.instance.requestCreateUser(userName: username!, password: password!)
        
        
    }
    @IBAction func SignInButtonPressed(_ sender: Any) {
        let username = LoginTextField.text
        let password = PasswordTextField.text
        Client.instance.requestPasswordValidation(userName: username!, password: password!)
        
    }
    
    func navigateToQuestionChoosing() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let questionsChoosingVC = storyBoard.instantiateViewController(withIdentifier: "QuestionChoosingVC") as! QuestionChoosingViewController
        self.present(questionsChoosingVC, animated: true, completion: nil)
    }
}
