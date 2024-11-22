//
//  MainPresenter.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 26.08.2024.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func tasksWasLoaded(tasks: [CoreDataToDoTask])
    func presentError()
    func createTask()
    func showTaskDetail(id: Int64)
    func taskWillDone(task: CoreDataToDoTask)
    func taskWillDelete(task: CoreDataToDoTask)
}

protocol CreateTaskDelegate: AnyObject {
    func didFinishTaskCreation()
}

class MainPresenter {
    
    weak var view: MainViewProtocol?
    var router: MainRouterProtocol
    var interactor: MainInteractorProtocol
    
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension MainPresenter: MainPresenterProtocol {
    func taskWillDelete(task: CoreDataToDoTask) {
        interactor.taskDelete(task: task)
    }
    
    func taskWillDone(task: CoreDataToDoTask) {
        interactor.taskDone(task: task)
    }

    
    func createTask() {
        router.createTask()
    }
    
    func viewDidLoaded() {
        guard let check = UserManager.shared.getInfoAboutLoaded(), !check else {
            interactor.loadTasksFromCoreData()
            return
        }
        interactor.saveTasksFromAPI()
    }
    func tasksWasLoaded(tasks: [CoreDataToDoTask]) {
        view?.changeTasks(tasks: tasks)
    }
    
    func presentError() {
        view?.showErrorMessage()
    }
    
    func showTaskDetail(id: Int64) {
        router.pushToDetail(id: id)
    }
}

extension MainPresenter: CreateTaskDelegate {
    func didFinishTaskCreation() {
        viewDidLoaded()
    }
}
