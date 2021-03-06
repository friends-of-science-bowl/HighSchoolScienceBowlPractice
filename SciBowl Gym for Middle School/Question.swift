//
//  Question.swift
//  SciBowl Gym for Middle School
//
//  Created by Jake Polatty on 7/11/17.
//  Copyright © 2017 Jake Polatty. All rights reserved.
//

import Foundation

struct Question {
    let questionText: String
    let category: Category
    let questionType: QuestionType
    let answerType: AnswerType
    let setNumber: Int
    let roundNumber: Int
    let questionNumber: Int
    let answerChoices: [String]?
    let answer: String
}

func convert(_ orig: String) -> String {
    var result = String()
    var math = false
    var escape = false
    for char in orig {
        if !escape && char == "$" {
            if math {
                math = false
                result += "\\;[/math]&nbsp;"
            } else {
                math = true
                result += "&nbsp;[math]\\;"
            }
        } else {
            if !escape && char == "\\" {
                escape = true
            } else {
                escape = false
            }
            result.append(char)
        }
    }
    return result
}

extension Question: Comparable {
    struct Key {
        static let questionText = "qTxt"
        static let questionAnswer = "qAns"
        static let answerChoices = "ansCh"
        static let category = "cat"
        static let setNumber = "sNum"
        static let roundNumber = "rNum"
        static let questionNumber = "qNum"
        static let answerType = "mc"
        static let questionType = "tb"
    }
    
    init?(json: [String: Any]) {
        guard
            let qText = json[Key.questionText] as? String,
            let qAnswer = json[Key.questionAnswer] as? String,
            let catString = json[Key.category] as? String,
            let setNumber = json[Key.setNumber] as? Int,
            let roundNumber = json[Key.roundNumber] as? Int,
            let questionNumber = json[Key.questionNumber] as? Int,
            let answerType = json[Key.answerType] as? String,
            let questionType = json[Key.questionType] as? String
        else {
            return nil;
        }
        
        self.questionText = convert(qText)
        self.answer = convert(qAnswer)
        self.setNumber = setNumber
        self.roundNumber = roundNumber
        self.questionNumber = questionNumber
        self.category = Category(catString: catString)
        self.answerType = AnswerType(typeString: answerType)
        self.questionType = QuestionType(typeString: questionType)
        
        if self.answerType == .multipleChoice {
            guard let ansChoices = json[Key.answerChoices] as? [String]
            else {
                return nil;
            }
            self.answerChoices = ansChoices.map{ convert($0) }
        } else {
            self.answerChoices = nil
        }
    }
    
    func id() -> Int {
        return (setNumber * 10000 + roundNumber * 100 + questionNumber)
            * (questionType == QuestionType.tossup ? -1 : 1)
    }
    
    static func < (this: Question, that: Question) -> Bool {
        if this.questionNumber == that.questionNumber {
            return this.questionType == .tossup
        }
        return this.questionNumber < that.questionNumber
    }
}
