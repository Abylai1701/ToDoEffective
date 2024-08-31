import Foundation

protocol CreateTaskPresenterProtocol: AnyObject {
    func createTask(task: NewTodo, completion: @escaping () -> Void)
    func dismissCreateTask()
}

class CreateTaskPresenter {
    
    weak var view: CreateTaskVCProtocol?
    var router: CreateTaskRouterProtocol
    var interactor: CreateTaskInteractorProtocol
    weak var delegate: CreateTaskDelegate?

    init(router: CreateTaskRouterProtocol, interactor: CreateTaskInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension CreateTaskPresenter: CreateTaskPresenterProtocol {
    func createTask(task: NewTodo,  completion: @escaping () -> Void) {
        interactor.createTask(task: task) {
            self.delegate?.didFinishTaskCreation()
            completion()
        }
    }
    
    func dismissCreateTask() {
        router.dismiss()
    }
}
