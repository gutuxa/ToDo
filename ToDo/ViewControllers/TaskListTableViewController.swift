//
//  ViewController.swift
//  ToDo
//
//  Created by Oksana Tugusheva on 11.05.2021.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    private let cellID = "cell"
    private let bgColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    private var tasks: [Task] = TaskData.shared.fetch()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(create)
        )
    }
    
    @objc private func create() {
        showAlert() { taskTitle in
            TaskData.shared.create(with: taskTitle) { task in
                self.tasks.append(task)
                let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    private func showAlert(for task: Task? = nil, completion: @escaping (String) -> Void) {
        let alert = AlertController(
            title: task != nil ? "Edit Task" : "New Task",
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        alert.action(for: task, completion: completion)
        present(alert, animated: true)
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
        cell.backgroundColor = bgColor
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        
        showAlert(for: task) { taskTitle in
            TaskData.shared.update(task, with: taskTitle)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let task = tasks.remove(at: indexPath.row)

            TaskData.shared.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

