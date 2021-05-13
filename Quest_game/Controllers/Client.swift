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

struct TopicsRequest : Encodable {
    var messageType = "topics"
    var count: Int
}

struct DifficultiesRequest : Encodable {
    var messageType = "difficulties"
    var count: Int
}
struct UserRequeest : Encodable {
    var messageType = "user"
    var id: Int
}
struct CreateUserRequest : Encodable {
    var messageType = "createUser"
    var userName: String
    var password : String
}


enum MessageType : String{
    case question = "question"
    case confirmation = "confirmation"
    case correctAnswer = "correctAnswer"
    case difficulties = "difficulties"
    case topics = "topics"
    case unknown = "unknown"
    case user = "user"
    case createUser = "createUser"
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
	
struct User {
 
    
    var id:Int = 0
    var userName:String = ""
    var score:Int = 0
    
    internal init(id: Int = 0, userName: String = "", score: Int = 0) {
        self.id = id
        self.userName = userName
        self.score = score
    }
}

class Client : StompClientLibDelegate
{
    init(
        url: URL,
        subscribePath: String,
        sendMessagePath: String
    ) {
        self.url = url
        self.subscribePath = subscribePath
        self.sendMessagePath = sendMessagePath
        socketClient = StompClientLib()
        Connect()
    }
    
    init(
    ) {
        socketClient = StompClientLib()
        Connect()
    }

    
    //Delegates
    typealias Action  = ()->Void
    typealias QuestionRecievedHandler = (Question)->Void
    typealias UserRecievedHandler = (User)->Void
    typealias ConfirmationRecievedHandler = (Bool,Int)->Void
    typealias CreateUserResultRecievedHandler = (Bool,Int)->Void
    typealias QuestionAnswerRecievedHandler = (String)->Void
    typealias TopicsRecievedHandler = ([String])->Void
    typealias DifficlutiesRecievedHandler = ([Int])->Void
    
    
    //Actions, which triggerd when some event occurs
    var OnQuestionRecieved: QuestionRecievedHandler!
    var OnConfirmationRecieved: ConfirmationRecievedHandler!
    var OnCorrectAnswerRecieved : QuestionAnswerRecievedHandler!
    var OnTopicsRecieved : TopicsRecievedHandler!
    var OnDifficlutiesRecieved: DifficlutiesRecievedHandler!
    var OnSocketConnected: Action!
    var OnSocketDisconnected: Action!
    var OnCreateUserResultRecieved : CreateUserResultRecievedHandler!
    var OnUserRecieved: UserRecievedHandler!
    
    
 
    // WARNING
    // THIS ADRESS IS TO BE CHANGED
    // IF YOU ARE NOT USING VM INSERT YOUR WINDOWS IPV4 ADAPTER IP HERE
    //let url = URL(string: "ws://tp-qg-heroku.herokuapp.com/questionSocket/websocket")!
    var url = URL(string: "ws://192.168.43.219:8080/questionSocket/websocket")!
    var subscribePath = "/topic/clientMessagePool"
    var sendMessagePath = "/app/serverMessagePool"
    var socketClient = StompClientLib()
    
    static var instance : Client = Client()

    	
  
    func requestSingleQuestion(topic:String,difficulty:String) {
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
    
    func requestTopics(count : Int) {
        
        let request = TopicsRequest(count: count)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    func requestDifficulties(count : Int) {
        
        let request = DifficultiesRequest(count: count)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    
    func requestCreateUser(userName : String, password : String) {
        let request = CreateUserRequest(userName: userName,password:password)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    func requestUser(id:Int) {
        let request = UserRequeest(id: id)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        print(jsonBody as Any)
        
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
            let id = jsonBody?["id"] as! Int
            if OnConfirmationRecieved  != nil {
            OnConfirmationRecieved(passwordIsValid,id)
            }
            break
        case .createUser:
            let existing : Bool = jsonBody?["alreadyExists"] as! Bool
            let id = jsonBody?["id"] as! Int
            if(OnCreateUserResultRecieved != nil){
                OnCreateUserResultRecieved(existing,id)
            }
            break
        case .topics:
            let topics = jsonBody?["topics"] as! [String]
            if(OnTopicsRecieved != nil){
                OnTopicsRecieved(topics)
            }
            break
        case .user:
            let user = User(id: jsonBody?["id"] as! Int,
                            userName: jsonBody?["name"] as! String,
                            score: jsonBody?["score"] as! Int)
            if(OnUserRecieved != nil ){
            OnUserRecieved(user)
            }
        case .difficulties:
            let difficulties = jsonBody?["difficulties"] as! [Int64]
            if(OnDifficlutiesRecieved != nil){
                //OnDifficlutiesRecieved(difficulties)
            }
            break			
        
        default:
            print("unknown message type recieved")
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

