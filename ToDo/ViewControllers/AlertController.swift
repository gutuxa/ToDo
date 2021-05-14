//
//  AlertController.swift
//  ToDo
//
//  Created by Oksana Tugusheva on 14.05.2021.
//

import UIKit

class AlertController: UIAlertController {
    func action(for task: Task? = nil, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let taskTitle = self.textFields?.first?.text, !taskTitle.isEmpty else { return }
            completion(taskTitle)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.title
        }
    }
}
