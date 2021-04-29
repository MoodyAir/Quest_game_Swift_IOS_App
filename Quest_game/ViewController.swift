//
//  ViewController.swift
//  Quest_game
//
//  Created by Admin on 28.04.2021.
//
import UIKit
import StompClientLib

struct QuestionRequest : Encodable {
    var topic:String
    var difficulty:String
}

class ViewController: UIViewController, StompClientLibDelegate {
 
    

    @IBOutlet weak var ConnectionLabel: UILabel!
    @IBOutlet weak var ConnectionSwitch: UISwitch!
    @IBOutlet weak var SendMessageButton: UIButton!
    
    var socketClient = StompClientLib()
    
    // WARNING
    // THIS ADRESS IS TO BE CHANGED
    // IF YOU ARE NOT USING VM INSERT YOUR WINDOWS IPV4 ADAPTER IP HERE
    let url = URL(string: "ws://192.168.0.101:8080/questionSocket/websocket")!
    let subscribePath = "/topic/questions"
    let sendMessagePath = "/app/question"

    override func viewDidLoad() {
            super.viewDidLoad()
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("Destination : \(destination)")
        print("String Body : \(stringBody ?? "nil")")
    }
    
    func serverDidSendPing() {
        print("Server ping")
        
    }

    @IBAction func SendMessageButtonPressed(_ sender: Any) {
        let request = QuestionRequest(topic : "Кино",difficulty : "100")
        let encodedData = try? JSONEncoder().encode(request)
        let jsonString = String(data: encodedData!,encoding: .utf8)!
        //"{topic : \"Кино\",difficulty : \"100\"}"
        socketClient.sendMessage(message: jsonString, toDestination: sendMessagePath, withHeaders: nil, withReceipt: nil)
        
        
    }
    
    @IBAction func subscribeAction() {
    }
    
    @IBAction func ConnectionSwitched(_ sender: Any) {
        if  ConnectionSwitch.isOn {
            Connect()
        }
        else{
            Disconnect()
        }
        
    }
    func Disconnect() {
        socketClient.disconnect()
    }
    
    func Connect() {
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
        
    }




    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print(jsonBody as Any)
    }

    func stompClientDidDisconnect(client: StompClientLib!) {
        ConnectionLabel.text = "Websocket disconnected!"
        print("Socket disconnected")
    }

    func stompClientDidConnect(client: StompClientLib!) {
        ConnectionLabel.text = "Websocket connected!"
        socketClient.subscribe(destination: subscribePath)
    }

    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("serverDidSendReceipt")

    }

    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("serverDidSendError")

    }
}
