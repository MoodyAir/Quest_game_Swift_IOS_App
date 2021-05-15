//
//  GameManager.swift
//  Quest_game
//
//  Created by Admin on 11.05.2021.
//

import Foundation
class GameManager
{
    static var currentQuestion : Question? = nil
    static var currentTopic : String!
    static var currentDifficulty : String!
    static var user :User!
    static var topicsCount = 5
    static var currentScore: Int = 0
    static var topics:[String]!
    static var topicsFinished:[Bool] = Array.init(repeating: false, count: topicsCount)
    static var finished:[[Bool]] = Array.init(repeating: topicsFinished, count: 5)
    static var difficulties : [Int] = [100,200,300,400,500]
    
    static func reset(){
        user = nil
        resetScore()
    }
    
    static func resetScore(){
        topics = []
        topicsFinished = Array.init(repeating: false, count: topicsCount)
        finished = Array.init(repeating: topicsFinished, count: 5)
        currentScore = 0
    }
    
    
    static func setFinished(topic: String, difficulty:String){
        let topicID = topics.firstIndex(of: topic)
        let difficultyID = difficulties.firstIndex(of: Int.init(difficulty)!)
        finished[topicID!][difficultyID!] = true
        for difficulty_finished in finished[topicID!] {
            if(!difficulty_finished){
                return
            }
        }
        topicsFinished[topicID!] = true
    }
    
    
    
}

