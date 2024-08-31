import Foundation
import CoreData

protocol TaskDetailInteractorProtocol: AnyObject {
    func takeTask()
    func taskDone()
    func taskDelete()
    func updateTask(title: String, description: String)
}

class TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    weak var presenter: TaskDetailPresenterProtocol?
    private let coreStore: CoreDataProtocol
    private var id: Int64
    var task: CoreDataToDoTask?
    
    init(coreStore: CoreDataProtocol, id: Int64) {
        self.coreStore = coreStore
        self.id = id
        self.task = fetchTaskById(id: id)
    }
    
    // Метод для извлечения задачи по id
    private func fetchTaskById(id: Int64) -> CoreDataToDoTask? {
        let fetchRequest: NSFetchRequest<CoreDataToDoTask> = CoreDataToDoTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            return try coreStore.context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch task: \(error.localizedDescription)")
            return nil
        }
    }
    
    func takeTask() {
        if let task = task {
            presenter?.taskDidLoad(task: task)
        } else {
            print("Task not found.")
        }
    }
    
    func taskDone() {
        guard let task = task else {
            print("Task not found.")
            return
        }
        
        task.completed = true
        
        coreStore.saveContext {
            self.presenter?.taskDidDone()
        }
    }
    func taskDelete() {
        coreStore.deleteTask(by: id) {
            self.presenter?.taskDidDone()
        }
    }
    func updateTask(title: String, description: String) {
        task?.todo = title
        task?.descrip = description
        coreStore.saveContext {
            print("Task updated successfully.")
            self.presenter?.taskDidDone()
        }
    }
}
