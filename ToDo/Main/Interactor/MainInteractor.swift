import Foundation
import CoreData

protocol MainInteractorProtocol: AnyObject {
    func saveTasksFromAPI()
    func loadTasksFromCoreData()
}

class MainInteractor {
    weak var presenter: MainPresenterProtocol?
    private let coreStore: CoreDataProtocol
    
    init(coreStore: CoreDataProtocol) {
        self.coreStore = coreStore
    }
    
    func saveTaskToCoreData(_ task: Todo, in context: NSManagedObjectContext) {
        let newTodoItem = CoreDataToDoTask(context: context)
        newTodoItem.id = Int64(task.id)
        newTodoItem.todo = task.todo
        newTodoItem.completed = task.completed
    }
}

extension MainInteractor: MainInteractorProtocol {
    func saveTasksFromAPI() {
        LoaderView.show()
        
        NetworkManager.shared.getRequest() { [weak self] (result: Result<Todos?, Error>) in
            guard let self = self else { return }
            
            LoaderView.hide()
            
            switch result {
            case .success(let todos):
                if let todos = todos?.todos {
                    let context = self.coreStore.context
                    todos.forEach { todo in
                        self.saveTaskToCoreData(todo, in: context)
                    }
                    do {
                        try context.save()
                        UserManager.shared.setInfoAboutLoaded(isLoaded: true)
                        self.loadTasksFromCoreData()
                    } catch {
                        print("Failed to save tasks: \(error.localizedDescription)")
                        self.presenter?.presentError()
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.presenter?.presentError()
            }
        }
    }
    
    func loadTasksFromCoreData() {
        let context = coreStore.context
        let fetchRequest: NSFetchRequest<CoreDataToDoTask> = CoreDataToDoTask.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            self.presenter?.tasksWasLoaded(tasks: tasks)
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            self.presenter?.presentError()
        }
    }
}
