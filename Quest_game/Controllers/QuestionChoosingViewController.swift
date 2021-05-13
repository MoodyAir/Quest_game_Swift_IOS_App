//
//  QuestionChoosingViewController.swift
//  Quest_game
//
//  Created by Admin on 09.05.2021.
//

import Foundation
import UIKit

class QuestionChoosingViewController : UIViewController
{
    
    @IBOutlet weak var TopicsStack: UIStackView!
    @IBOutlet weak var DifficultiesStack: UIStackView!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var SelectDifficultyLabel: UILabel!
    @IBOutlet weak var SelectAnotherDifficultyButton: UIButton!
    
    var topicButtons : [UIButton]=[]
    var difficultiesButtons : [UIButton]=[]
    var selectedTopic : String!
    var selectedDifficulty : String!
   
    override func viewDidLoad() {
        Client.instance.Connect()
      

        //GameManager.topics = ["A","B","C","D","E"]
        fillTopicsStack()
        fillDifficultiesStack()
        refreshTopicStack()
        SelectAnotherDifficultyButton.isHidden = true

    }
    
    
    var topicsCounter = 0
    func AddTopicButton( topic : String) {
        topicButtons.append(UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 75)))
        topicButtons[topicsCounter].backgroundColor = .black
        topicButtons[topicsCounter].setTitle(topic,for: UIControl.State.normal)
        topicButtons[topicsCounter].addTarget(self, action: #selector(topicButtonPressed),for: UIControl.Event.touchUpInside)
        TopicsStack.addArrangedSubview(topicButtons[topicsCounter])
    }
    
    
    func fillTopicsStack() {
        topicsCounter = 0
        for topic in GameManager.topics {
            AddTopicButton(topic: topic)
            topicsCounter+=1
        }
    }
    func refreshTopicStack(){
        
        for topic in GameManager.topics {
            let topicID:Int = GameManager.topics.firstIndex(of: topic)!
            TopicsStack.arrangedSubviews[topicID].isHidden = GameManager.topicsFinished[topicID]
        }
    }
    
    @objc func topicButtonPressed(sender: UIButton!) {
        let topic = sender.currentTitle
        selectedTopic = topic
        TopicsStack.isHidden = true
        DifficultiesStack.isHidden = false
        StatusLabel.text = "Topic: "+topic!
        refreshDifficultiesStack(topic: topic!)
        SelectAnotherDifficultyButton.isHidden = false
        SelectDifficultyLabel.isHidden = false
    }
    @IBAction func SelectTopicButtonPressed(_ sender: Any){
        showTopicsSelection()
    }
    func showTopicsSelection() {
        SelectDifficultyLabel.isHidden = true
        SelectAnotherDifficultyButton.isHidden  = true
        TopicsStack.isHidden = false
        DifficultiesStack.isHidden = true
        StatusLabel.text = "Select topic"
        refreshTopicStack()
    }
    
    func AddDifficultyButton( difficulty : String) {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 75))
        button.backgroundColor = .black
        button.setTitle(difficulty,for: UIControl.State.normal)
        button.addTarget(self, action: #selector(difficultyButtonPressed),for: UIControl.Event.touchUpInside)
        DifficultiesStack.addArrangedSubview(button)
       // difficultiesButtons.append(button)
    }
    
    @objc func difficultyButtonPressed(sender : UIButton!) {
        selectedDifficulty = sender.currentTitle
        GameManager.currentTopic = selectedTopic
        GameManager.currentDifficulty = selectedDifficulty
        print("Selected: " + selectedTopic + " | " + selectedDifficulty)
        navigateToAnswering()
//        GameManager.setFinished(topic: selectedTopic, difficulty: selectedDifficulty)
//        refreshDifficultiesStack(topic: selectedTopic)
        
    }
    
    
    func fillDifficultiesStack(){
        for difficulty in GameManager.difficulties {
                AddDifficultyButton(difficulty: String.init(difficulty))
            }
        }
        
    
    
    func refreshDifficultiesStack(topic:String){
        let topicID:Int = GameManager.topics.firstIndex(of: topic)!
        var i = 0
        for _ in GameManager.difficulties {
            DifficultiesStack.arrangedSubviews[i].isUserInteractionEnabled = !GameManager.finished[topicID][i]
            if GameManager.finished[topicID][i]{
                DifficultiesStack.arrangedSubviews[i].backgroundColor = UIColor.lightGray
            }
            else{
                DifficultiesStack.arrangedSubviews[i].backgroundColor = UIColor.black
            }
        
            i+=1
        }
        if GameManager.topicsFinished[topicID] {
            showTopicsSelection()
        }
        
    }
    
    @IBAction func BackToLogin(_ sender: Any) {
        navigateToLogin()
    }
    
    
    func navigateToLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        GameManager.reset()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func navigateToAnswering(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let QAVC = storyBoard.instantiateViewController(withIdentifier: "QuestionAnsweringVC") as! QuestionAnsweringViewController
        self.present(QAVC, animated: true, completion: nil)
    }
}
