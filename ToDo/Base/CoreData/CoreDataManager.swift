import Foundation
import CoreData

protocol CoreDataProtocol: AnyObject {
    var context: NSManagedObjectContext { get }
    func saveContext(completion: @escaping () -> Void)
    func saveTask(_ task: NewTodo, id: Int64, completion: @escaping () -> Void)
    func fetchTasks(completion: @escaping ([CoreDataToDoTask]) -> Void)
    func getNextTaskId() -> Int64
    func deleteTask(by id: Int64, completion: @escaping () -> Void)
}

class CoreDataManager: CoreDataProtocol {
    
    static let shared = CoreDataManager(modelName: "ToDo")
    
    private let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: Инициализатор для тестов
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext(completion: @escaping () -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([CoreDataToDoTask]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest: NSFetchRequest<CoreDataToDoTask> = CoreDataToDoTask.fetchRequest()
            do {
                let tasks = try self.context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Failed to fetch tasks: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    
    func saveTask(_ task: NewTodo, id: Int64, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let newTodoItem = CoreDataToDoTask(context: self.context)
            newTodoItem.id = id
            newTodoItem.todo = task.title
            newTodoItem.descrip = task.description
            newTodoItem.completed = task.completed
            newTodoItem.date = task.date
            DispatchQueue.main.async {
                self.saveContext(completion: completion)
                print("id: \(id)")
                print("title: \(task.title ?? "")")
                print("description: \(task.description ?? "")")
                print("completed: \(task.completed)")
                print("date: \(task.date ?? "")")
            }
        }
    }
    func getNextTaskId() -> Int64 {
        let fetchRequest: NSFetchRequest<CoreDataToDoTask> = CoreDataToDoTask.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let lastTask = try context.fetch(fetchRequest).first
            return (lastTask?.id ?? 0) + 1
        } catch {
            print("Failed to fetch last id: \(error.localizedDescription)")
            return 1
        }
    }
    func deleteTask(by id: Int64, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest: NSFetchRequest<CoreDataToDoTask> = CoreDataToDoTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                if let taskToDelete = try self.context.fetch(fetchRequest).first {
                    self.context.delete(taskToDelete)
                    
                    DispatchQueue.main.async {
                        self.saveContext(completion: completion)
                        print("Deleted task with id: \(id)")
                    }
                } else {
                    print("Task with id: \(id) not found.")
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } catch {
                print("Failed to delete task: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
