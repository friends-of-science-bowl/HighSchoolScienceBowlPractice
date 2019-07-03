//
//  QuestionType.swift
//  SciBowl Gym for Middle School
//
//  Created by Emily Liu on 6/29/19.
//  Copyright © 2019 Friends of Science Bowl. All rights reserved.
//

import Foundation

enum QuestionType {
    case tossup
    case bonus
    
    init (typeString: String) {
        switch typeString {
        case "T": self = .tossup
        case "B": self = .bonus
        default: self = .tossup
        }
    }
}

extension QuestionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .tossup: return "Tossup"
        case .bonus: return "Bonus"
        }
    }
}

