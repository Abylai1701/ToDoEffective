//
//  CreateTaskInteractor.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 28.08.2024.
//

import Foundation
import CoreData

protocol CreateTaskInteractorProtocol: AnyObject {
    func createTask(task: NewTodo, completion: @escaping () -> Void)
}


class CreateTaskInteractor {
    weak var presenter: CreateTaskPresenterProtocol?
    private let coreStore: CoreDataProtocol
    
    init(coreStore: CoreDataProtocol) {
        self.coreStore = coreStore
    }
}

extension CreateTaskInteractor: CreateTaskInteractorProtocol {
    
    func createTask(task: NewTodo, completion: @escaping () -> Void) {
        let id = coreStore.getNextTaskId()
        coreStore.saveTask(task, id: id, completion: completion)
    }
}
