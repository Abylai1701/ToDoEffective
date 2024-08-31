//
//  NewToDo.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 28.08.2024.
//

import Foundation

struct NewTodo: Codable {
    let title: String?
    let description: String?
    let completed: Bool
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case  title, description, completed, date
    }
}
