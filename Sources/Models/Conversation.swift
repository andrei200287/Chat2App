//
//  Conversation.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

struct Conversation: Codable {
    let customerId: Int
    let name: String
    @DateFromInt var dt: Date
    let appVersion: String
    let locale: String
    let text: String
    @BoolFromInt var isAnswer: Bool
    var unReadCnt: Int
    let type: Int
    let appName: String
}
