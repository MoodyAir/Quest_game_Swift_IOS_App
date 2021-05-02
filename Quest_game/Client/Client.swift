//
//  QuestionClient.swift
//  Quest_game
//
//  Created by Admin on 30.04.2021.
//

import Foundation
import StompClientLib

//struct QuestionRequest : Encodable {
//    var topic:String
//    var difficulty:String
//}

class Client : StompClientLibDelegate
{
    
    init(
        url: URL = URL(string: "ws://localhost:8080/questionSocket/websocket")!,
        subscribePath: String = "/topic/single_question",
        sendMessagePath: String = "/app/single_question"
    ) {
        self.url = url
        self.subscribePath = subscribePath
        self.sendMessagePath = sendMessagePath
        socketClient = StompClientLib()
    }

    
    //Delegates
    typealias Action  = ()->Void
    typealias DataRecievedHandler = (Question)->Void
    
    
    //Actions, which triggerd when some event occurs
    var OnDataRecieved:  DataRecievedHandler!
    var OnSocketConnected: Action!
    var OnSocketDisconnected: Action!
    
    
    
    
    
    // WARNING
    // THIS ADRESS IS TO BE CHANGED
    // IF YOU ARE NOT USING VM INSERT YOUR WINDOWS IPV4 ADAPTER IP HERE
    
    var url = URL(string: "ws://localhost:8080/questionSocket/websocket")!
    var subscribePath = "/topic/single_question"
    var sendMessagePath = "/app/single_question"

    
    
    var socketClient = StompClientLib()



    func Disconnect() {
        socketClient.disconnect()
    }

    func Connect() {
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
    }
    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print(jsonBody as Any)
    }

    func JSONObjectAction(jsonBody:AnyObject?){
        preconditionFailure("This method must be overridden")
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        JSONObjectAction(jsonBody: jsonBody)
       
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

}

