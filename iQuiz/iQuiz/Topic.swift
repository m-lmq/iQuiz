//
//  Topic.swift
//  iQuiz
//
//  Created by Maggie Liang on 5/10/24.
//

import Foundation

struct Topic: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}
