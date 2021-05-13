//
//  QuestionClient.swift
//  Quest_game
//
//  Created by Admin on 02.05.2021.
//

import Foundation

class QuestionClient : Client
{
    
    override func JSONObjectAction(jsonBody:AnyObject?){
        let question = Question(id: jsonBody?["id"] as! Int,
                                text: jsonBody?["text"] as! String,
                                topic: jsonBody?["topic"] as! String,
                                difficulty: jsonBody?["difficulty"] as! Int
                                )
        
        if (OnDataRecieved != nil){
            OnDataRecieved(question)
        }
    }
    
    struct QuestionRequest : Encodable {
        var topic:String
        var difficulty:String
    }
    
    func RequestSingleQuestion(topic:String,difficulty:String) {
        let request = QuestionRequest(topic : topic,difficulty : difficulty)
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        //"{topic : "Кино",difficulty : "100"}"
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        print("Message " + jsonString + " sent to destination " + sendMessagePath)    
    }
    
}
