//
//  AnswerType.swift
//  SciBowl Gym for Middle School
//
//  Created by Yaxin Liu on 6/29/19.
//  Copyright © 2019 Friends of Science Bowl. All rights reserved.
//

import Foundation

enum AnswerType {
    case multipleChoice
    case shortAnswer
    
    init(typeString: String) {
        switch typeString {
        case "MC": self = .multipleChoice
        case "SA": self = .shortAnswer
        default: self = .shortAnswer
        }
    }
}

extension AnswerType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .multipleChoice: return "Multiple Choice"
        case .shortAnswer: return "Short Answer"
        }
    }
}

