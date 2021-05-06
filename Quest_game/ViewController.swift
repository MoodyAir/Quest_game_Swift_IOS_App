//
//  ViewController.swift
//  Quest_game
//
//  Created by Admin on 28.04.2021.
//
import UIKit
import StompClientLib







class ViewController: UIViewController {

    @IBOutlet weak var ConnectionLabel: UILabel!
    @IBOutlet weak var ConnectionSwitch: UISwitch!
    @IBOutlet weak var SendMessageButton: UIButton!
    
    	
    
    
    // WARNING
    // THIS ADRESS IS TO BE CHANGED
    // IF YOU ARE NOT USING VM INSERT YOUR WINDOWS IPV4 ADAPTER IP HERE
    //let url = URL(string: "ws://192.168.0.102:8080/questionSocket/websocket")!
    let url = URL(string: "ws://192.168.0.102:8080/questionSocket/websocket")!
    var subscribePath = "/topic/clientMessagePool"
    var sendMessagePath = "/app/serverMessagePool"
    
    var client : Client!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = Client(url: url, subscribePath: subscribePath, sendMessagePath: sendMessagePath)
        
        client.OnQuestionRecieved = {(question:Question) ->Void in
            print(question)
            self.client.requestCorrectAnswer(id: question.id)
        }
        client.OnConfirmationRecieved = {(passwordIsValid:Bool) ->Void in
            if(passwordIsValid){
                print("login and password are valid")
            }
            else{
                print("login and password are wrong")
            }
        }
        client.OnCorrectAnswerRecieved = {(correctAnswer:String) ->Void in
            print("Correct answer : " + correctAnswer)
        }
        client.OnSocketConnected = {()->Void in
            self.ConnectionLabel.text = "Websocket Connected"
        }
        client.OnSocketDisconnected = {()->Void in
            self.ConnectionLabel.text = "Websocket Disconnected"
        }
    }
    
    
    @IBAction func SendMessageButtonPressed(_ sender: Any) {
        client.RequestSingleQuestion(topic: "Кино", difficulty:  "100")
        client.requestPasswordValidation(userName: "Kirill", password: "1234")
        
    }
    
    @IBAction func ConnectionSwitched(_ sender: Any) {
        if  ConnectionSwitch.isOn {
            client.Connect()
        }
        else{
            client.Disconnect()
        }
    }
 
}
