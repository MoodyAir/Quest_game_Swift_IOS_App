//
//  GameEndViewController.swift
//  Quest_game
//
//  Created by Admin on 09.05.2021.
//

import Foundation
import UIKit
class MenuVC : UIViewController
{
    
    @IBOutlet weak var RecordScoreLabel: UILabel!
    override func viewDidLoad() {
        RecordScoreLabel.text = "Ваш рекорд: "+String.init(GameManager.user.score)
    }
    
    @IBAction func ChangeAccountButtonPressed(_ sender: Any) {
        GameManager.reset()
        navigateToLogin()
    }
    @IBAction func NewGameButtonPressed(_ sender: Any) {
        GameManager.resetScore()
        Client.instance.OnTopicsRecieved = {(topics:[String]) in
            GameManager.topics = topics
            print(topics)
            self.navigateToQuestionChoosing()
        }
        Client.instance.requestTopics(count: GameManager.topicsCount)
       
    }	
  
    
    func navigateToLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func navigateToQuestionChoosing() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let questionsChoosingVC = storyBoard.instantiateViewController(withIdentifier: "QuestionChoosingVC") as! QuestionChoosingViewController
        self.present(questionsChoosingVC, animated: true, completion: nil)
    }
    
}
