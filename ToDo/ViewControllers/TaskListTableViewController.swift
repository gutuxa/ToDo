//
//  ViewController.swift
//  ToDo
//
//  Created by Oksana Tugusheva on 11.05.2021.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    private let cellID = "cell"
    private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        tasks = TaskData.shared.fetch()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(add)
        )
            
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func add() {
        showAlert(with: "New Task", for: nil)
    }
    
    private func showAlert(with title: String, for row: Int?) {
        let alert = UIAlertController(
            title: title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let taskTitle = alert.textFields?.first?.text, !taskTitle.isEmpty else { return }
            if let row = row {
                self.update(at: row, with: taskTitle)
            } else {
                self.create(with: taskTitle)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "New Task"
            
            if let row = row {
                textField.text = self.tasks[row].title
            }
        }
        
        present(alert, animated: true)
    }
    
    private func create(with title: String) {
        guard let task = TaskData.shared.create(with: title) else { return }
        tasks.append(task)
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    private func update(at row: Int, with title: String) {
        let task = tasks[row]
        
        guard TaskData.shared.update(task, with: title) else { return }
        
        let indexPath = IndexPath(row: row, section: 0)
        task.title = title
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func delete(at row: Int) {
        let task = tasks.remove(at: row)
        
        guard TaskData.shared.delete(task) else { return }
        
        let indexPath = IndexPath(row: row, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = tasks[indexPath.row].title
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(with: "Edit Task", for: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            delete(at: indexPath.row)
        }
    }
}

