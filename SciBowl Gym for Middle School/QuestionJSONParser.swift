//
//  QuestionJSONParser.swift
//  SciBowl Gym for Middle School
//
//  Created by Jake Polatty on 7/11/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import GameKit
import Foundation

struct QuestionJSONParser {
    var parsedQuestions = [Question]()
    var byCategory = [Category: [Question]]()
    var byRound = [Int: [Question]]()
    var byCategoryRound = [Category: [Int: [Question]]]()
    var bySetRound = [Int: [Int: [Question]]]()
    
    static let shared = QuestionJSONParser()
    
    static func parseJsonFile(withName name: String) -> [[String: Any]] {
        let file = Bundle.main.path(forResource: name, ofType: "json")
        let data = try! Data.init(contentsOf: URL(fileURLWithPath: file!))
        let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
        return jsonData
    }
    
    init() {
        let parsedJSON = QuestionJSONParser.parseJsonFile(withName: "questions")
        for questionJSON in parsedJSON {
            if let parsedQuestion = Question(json: questionJSON) {
                parsedQuestions.append(parsedQuestion)
                let cat = parsedQuestion.category
                let round = parsedQuestion.roundNumber
                let set = parsedQuestion.setNumber
                // by category
                if byCategory[cat] == nil {
                    byCategory[cat] = [Question]()
                }
                byCategory[cat]!.append(parsedQuestion)
                // by round
                if byRound[round] == nil {
                    byRound[round] = [Question]()
                }
                byRound[round]!.append(parsedQuestion)
                // by category round
                if byCategoryRound[cat] == nil {
                    byCategoryRound[cat] = [Int: [Question]]()
                }
                if byCategoryRound[cat]![round] == nil {
                    byCategoryRound[cat]![round] = [Question]()
                }
                byCategoryRound[cat]![round]!.append(parsedQuestion)
                // by set round
                if bySetRound[set] == nil {
                    bySetRound[set] = [Int: [Question]]()
                }
                if bySetRound[set]![round] == nil {
                    bySetRound[set]![round] = [Question]()
                }
                bySetRound[set]![round]!.append(parsedQuestion)
            }
        }
        for set in bySetRound.keys {
            for round in bySetRound[set]!.keys {
                bySetRound[set]![round]!.sort()
            }
        }
    }
    
    func getRandomQuestion() -> Question {
        return parsedQuestions.randomElement()!
    }
    
    func getQuestionForCategory(_ category: Category) -> Question {
        return byCategory[category]!.randomElement()!
    }
    
    func getQuestionForCategory(_ category: Category, andRound round: Int) -> Question {
        return byCategoryRound[category]![round]!.randomElement()!
    }
    
    func getQuestionForRound(_ round: Int) -> Question {
        return byRound[round]!.randomElement()!
    }
    
    func getQuestionSet(_ set: Int, forRound round: Int) -> [Question] {
        return bySetRound[set]![round]!
    }
    
    func getMCQuestion() -> Question {
        while true {
            let question = getRandomQuestion()
            if question.answerType == .multipleChoice {
                return question
            }
        }
    }
    
    func getMCQuestionForCategory(_ category: Category) -> Question {
        while true {
            let question = getQuestionForCategory(category)
            if question.answerType == .multipleChoice {
                return question
            }
        }
    }
}





