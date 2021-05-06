//
//  QuestionClient.swift
//  Quest_game
//
//  Created by Admin on 30.04.2021.
//

import Foundation
import StompClientLib

struct QuestionRequest : Encodable {
    var messageType = "question"
    var topic:String
    var difficulty:String
}
struct PasswordValidationRequest : Encodable {
    var messageType = "confirmation"
    var userName:String
    var password:String
}
struct CorrectAnswerRequest : Encodable {
    var messageType = "correctAnswer"
    var id: Int
}

enum MessageType : String{
    case question = "question"
    case confirmation = "confirmation"
    case correctAnswer = "correctAnswer"
    case unknown = "unknown"
}

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
	
class Client : StompClientLibDelegate
{
    init(
        url: URL = URL(string: "ws://localhost:8080/questionSocket/websocket")!,
        subscribePath: String = "/topic/clientMessagePool",
        sendMessagePath: String = "/app/serverMessagePool"
    ) {
        self.url = url
        self.subscribePath = subscribePath
        self.sendMessagePath = sendMessagePath
        socketClient = StompClientLib()
    }

    
    //Delegates
    typealias Action  = ()->Void
    typealias QuestionRecievedHandler = (Question)->Void
    typealias ConfirmationRecievedHandler = (Bool)->Void
    typealias QuestionAnswerRecievedHandler = (String)->Void
    
    
    //Actions, which triggerd when some event occurs
    var OnQuestionRecieved: QuestionRecievedHandler!
    var OnConfirmationRecieved: ConfirmationRecievedHandler!
    var OnCorrectAnswerRecieved : QuestionAnswerRecievedHandler!
    var OnSocketConnected: Action!
    var OnSocketDisconnected: Action!
    
    
 
    var url = URL(string: "ws://localhost:8080/questionSocket/websocket")!
    var subscribePath = "/topic/clientMessagePool"
    var sendMessagePath = "/app/serverMessagePool"
    var socketClient = StompClientLib()


  
    func RequestSingleQuestion(topic:String,difficulty:String) {
        let request = QuestionRequest(topic : topic,difficulty : difficulty)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        
        //"{topic : "Кино",difficulty : "100"}"
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    func requestPasswordValidation(userName:String,password:String){
        
        let request = PasswordValidationRequest(userName : userName,password : password)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    func requestCorrectAnswer(id:Int){
        
        let request = CorrectAnswerRequest(id: id)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        let messageType =  MessageType(rawValue: (jsonBody?["messageType"] as! String) )
        switch messageType {
        case .question:
            let question = Question(id: jsonBody?["id"] as! Int,
                                    text: jsonBody?["text"] as! String,
                                    topic: jsonBody?["topic"] as! String,
                                    difficulty: jsonBody?["difficulty"] as! Int
                                    )
            if (OnQuestionRecieved != nil) {
                OnQuestionRecieved(question)
            }
            break
        case .correctAnswer:
            let correctAnswer = jsonBody?["correctAnswer"] as! String
            if OnCorrectAnswerRecieved != nil{
            OnCorrectAnswerRecieved(correctAnswer)
            }
            break
        case .confirmation:
            let passwordIsValid = jsonBody?["passwordIsValid"] as! Bool
            if OnConfirmationRecieved  != nil {
            OnConfirmationRecieved(passwordIsValid)
            }
	            break
        default:
            print("unknown message type")
            break
        }
    
       
    }


    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket disconnected")
        if (OnSocketDisconnected != nil){
        OnSocketDisconnected()
        }
        
    }

    func stompClientDidConnect(client: StompClientLib!) {
        socketClient.subscribe(destination: subscribePath)
        	
        if (OnSocketConnected != nil){
        OnSocketConnected()
        }
    }

    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("serverDidSendReceipt")

    }

    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("serverDidSendError")
    }
    func serverDidSendPing() {
        print("Server ping")
    }
    func Connect() {
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
    }
    func Disconnect() {
        socketClient.disconnect()
    }

    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print(jsonBody as Any)
    }


}

