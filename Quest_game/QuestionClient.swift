////
////  QuestionClient.swift
////  Quest_game
////
////  Created by Admin on 30.04.2021.
////
//
//import Foundation
//import StompClientLib
//
////struct QuestionRequest : Encodable {
////    var topic:String
////    var difficulty:String
////}
//
//class QuestionClient : StompClientLibDelegate
//{
//    var socketClient = StompClientLib()
//    init() {
//        Connect()
//    }
//
//    // WARNING
//    // THIS ADRESS IS TO BE CHANGED
//    // IF YOU ARE NOT USING VM INSERT YOUR WINDOWS IPV4 ADAPTER IP HERE
//    let url = URL(string: "ws://192.168.0.101:8080/questionSocket/websocket")!
//    let subscribePath = "/topic/questions"
//    let sendMessagePath = "/app/question"
//
//    func serverDidSendPing() {
//        print("Server ping")
//    }
//
//    func RequestQuestion(topic:String,difficulty:String) {
//        let request = QuestionRequest(topic : topic,difficulty : topic)
//        let encodedData = try? JSONEncoder().encode(request)
//        let jsonString = String(data: encodedData!,encoding: .utf8)!
//        //"{topic : "Кино",difficulty : "100"}"
//        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
//    }
//
//
//    func Disconnect() {
//        socketClient.disconnect()
//    }
//
//    func Connect() {
//        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
//
//    }
//
//
//    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
//        print(jsonBody as Any)
//    }
//
//    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
//        print("Destination : \(destination)")
//        print("String Body : \(stringBody ?? "nil")")
//    }
//
//
//    func stompClientDidDisconnect(client: StompClientLib!) {
//        print("Socket disconnected")
//    }
//
//    func stompClientDidConnect(client: StompClientLib!) {
//        socketClient.subscribe(destination: subscribePath)
//        socketClient.subscribe(destination: "topic/questions")
//    }
//
//    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
//        print("serverDidSendReceipt")
//
//    }
//
//    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
//        print("serverDidSendError")
//
//    }
//
//}
//
