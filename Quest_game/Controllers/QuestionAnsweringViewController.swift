//
//  QuestionAnsweringViewController.swift
//  Quest_game
//
//  Created by Admin on 09.05.2021.
//

import Foundation
import  UIKit
class QuestionAnsweringViewController : UIViewController
{
    
    @IBOutlet weak var TopicDIfficultyLabel: UILabel!
    @IBOutlet weak var QuestionTextLabel: UILabel!
    @IBOutlet weak var AnswerTextField: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var SubmitButton: UIButton!
    var answer:String!
    
    override func viewDidLoad() {
        Client.instance.OnQuestionRecieved = {(question:Question) in
            self.TopicDIfficultyLabel.text = ("Тема: " + question.topic + " | Сложность: " + String.init( question.difficulty ))
            self.QuestionTextLabel.text = question.text
            GameManager.currentQuestion = question
        }
        Client.instance.OnCorrectAnswerRecieved = {(correctAnswer:String) in
            self.ResultLabel.isHidden = false
            self.ContinueButton.isHidden = false
            if  correctAnswer.lowercased() != self.answer.lowercased() {
                self.ResultLabel.text = "Неверно! Правильный ответ : \n" + correctAnswer
               
            }
            else{
                self.ResultLabel.text = "Верно!"
                GameManager.currentScore += Int.init(GameManager.currentDifficulty)!
            }
            GameManager.setFinished(topic: GameManager.currentTopic, difficulty: GameManager.currentDifficulty)
            
         }
        Client.instance.requestSingleQuestion(topic: GameManager.currentTopic, difficulty: GameManager.currentDifficulty)
    }
    
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        answer = AnswerTextField.text
        let id = GameManager.currentQuestion?.id
        Client.instance.requestCorrectAnswer(id: id!)
        SubmitButton.isHidden = true;
    }
    @IBAction func ContinueButtonPressed(_ sender: Any) {
        navigateToQuestionChoosing()
    }
    func navigateToQuestionChoosing() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let questionsChoosingVC = storyBoard.instantiateViewController(withIdentifier: "QuestionChoosingVC") as! QuestionChoosingViewController
        self.present(questionsChoosingVC, animated: true, completion: nil)
    }
}
