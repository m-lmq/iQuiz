//
//  Question.swift
//  iQuiz
//
//  Created by Maggie Liang on 5/10/24.
//

import Foundation

struct Question: Codable {
    let text: String
    let answer: String
    let answers: [String]
}
