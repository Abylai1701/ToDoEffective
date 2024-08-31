//
//  ViewController.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 24.08.2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func changeTasks(tasks: [CoreDataToDoTask])
    func showErrorMessage()
    func reloadData()
}

final class MainVC: UIViewController {

    var presenter: MainPresenterProtocol?
    private let refreshControl = UIRefreshControl()
    var tasks: [CoreDataToDoTask] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "ToDo List"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        refreshControl.addTarget(self,
                                 action: #selector(refreshPage),
                                 for: .valueChanged)
        refreshControl.tintColor = .blue
        table.refreshControl = refreshControl
        table.register(MainCell.self,
                       forCellReuseIdentifier: MainCell.cellId)
        table.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        return table
    }()
    private lazy var createButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .medium
        configuration.title = "Создать"
        configuration.baseForegroundColor = .white
        configuration.image = UIImage(named: "file_add")
        configuration.imagePadding = 24
        configuration.imagePlacement = .leading
        configuration.buttonSize = .medium
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self,
                         action: #selector(goToCreate),
                         for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(tableView, createButton, mainLabel)

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(203)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MainCell.cellId,
            for: indexPath) as! MainCell
        cell.configure(model: tasks[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear 
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = tasks[indexPath.row]
        presenter?.showTaskDetail(id: todo.id)
    }
}
extension MainVC: MainViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func changeTasks(tasks: [CoreDataToDoTask]) {
        self.tasks = tasks
    }
    
    func showErrorMessage() {
        showErrorMessage(messageType: .error, "")
    }
}
extension MainVC {
    @objc private func goToCreate() {
        presenter?.createTask()
    }
    @objc private func refreshPage() {
        presenter?.viewDidLoaded()
        refreshControl.endRefreshing()
    }
}
