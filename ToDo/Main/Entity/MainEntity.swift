//
//  MainEntity.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 28.08.2024.
//

import Foundation

struct Todos: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
