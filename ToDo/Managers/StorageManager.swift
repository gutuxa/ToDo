//
//  StorageManager.swift
//  ToDo
//
//  Created by Oksana Tugusheva on 11.05.2021.
//

import CoreData

class TaskData {
    static let shared = TaskData()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private init() {}
    
    func fetch() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            return taskList
        } catch let error {
            print(error)
            return []
        }
    }
    
    func create(with title: String) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return nil }
        
        task.title = title
        let created = commitChanges()
        
        return created ? task : nil
    }
    
    func update(_ task: Task, with title: String) -> Bool {
        task.setValue(title, forKey: "title")
        return commitChanges()
    }
    
    func delete(_ task: Task) -> Bool {
        context.delete(task)
        return commitChanges()
    }
    
    private func commitChanges() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return false
    }
}
