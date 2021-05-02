//
//  ViewController.swift
//  Quest_game
//
//  Created by Admin on 28.04.2021.
//
import UIKit
import StompClientLib



struct Question {
    var id:Int = 0
    var text:String = ""
    var topic:String = ""
    var difficulty:Int = 0

    internal init(id: Int = 0, text: String = "", topic: String = "", difficulty: Int = 0) {
        self.id = id
        self.text = text
        self.topic = topic
        self.difficulty = difficulty
    }
}



class ViewController: UIViewController {

    @IBOutlet weak var ConnectionLabel: UILabel!
    @IBOutlet weak var ConnectionSwitch: UISwitch!
    @IBOutlet weak var SendMessageButton: UIButton!
    let url = URL(string: "ws://192.168.0.102:8080/questionSocket/websocket")!
    //let url = URL(string: "ws://192.168.43.219:8080/questionSocket/websocket")!
    let questionsSubscribePath = "/topic/single_question"
    let questionsSendMessagePath = "/app/single_question"
    let usersValidationSubscribePath = "/topic/validate"
    let usersValidationSendMessagePath = "/app/validate"
    
    var questionClient: QuestionClient!
    var usersClient: UsersClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionClient = QuestionClient(url: url,
                                        subscribePath: questionsSubscribePath,
                                        sendMessagePath: questionsSendMessagePath)
        
        usersClient = UsersClient(url: url,
                                        subscribePath: usersValidationSubscribePath,
                                        sendMessagePath: usersValidationSendMessagePath)
        
        
            
        questionClient.OnDataRecieved = {(question:Question) ->Void in
            print(question)
        }
        questionClient.OnSocketConnected = {()->Void in
            self.ConnectionLabel.text = "Websocket Connected"
        }
        questionClient.OnSocketDisconnected = {()->Void in
            self.ConnectionLabel.text = "Websocket Disconnected"
        }
    }
    
    
    @IBAction func SendMessageButtonPressed(_ sender: Any) {
        questionClient.RequestSingleQuestion(topic: "Кино", difficulty:  "100")
        //usersClient.requestPasswordValidation(userName: "Kirill", password: "1234")
        
    }
    
    @IBAction func ConnectionSwitched(_ sender: Any) {
        if  ConnectionSwitch.isOn {
            questionClient.Connect()
        }
        else{
            questionClient.Disconnect()
        }
    }
 
}
