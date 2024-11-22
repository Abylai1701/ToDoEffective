//
//  TaskDetailPresenter.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 30.08.2024.
//

import Foundation


protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func taskDidLoad(task: CoreDataToDoTask)
    func saveTaskChanges(title: String, description: String)
    func taskDidUpdate()
}

class TaskDetailPresenter {
    
    weak var view: TaskDetailViewProtocol?
    var router: TaskDetailRouterProtocol
    var interactor: TaskDetailInteractorProtocol
    weak var delegate: CreateTaskDelegate?

    init(router: TaskDetailRouterProtocol, interactor: TaskDetailInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
 
    func taskDidLoad(task: CoreDataToDoTask) {
        view?.loadTaskInfo(task: task)
    }
    
   
    func viewDidLoaded() {
        interactor.takeTask()
    }
    
    func taskDidUpdate() {
        view?.taskDidUpdate()
    }

    func saveTaskChanges(title: String, description: String) {
        interactor.updateTask(title: title, description: description)
    }
}
extension TaskDetailPresenter: CreateTaskDelegate {
    func didFinishTaskCreation() {
        viewDidLoaded()
    }
}
