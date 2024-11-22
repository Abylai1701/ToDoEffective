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
    
    //MARK: Properties
    var presenter: MainPresenterProtocol?
    private let refreshControl = UIRefreshControl()
    private var allTasks: [CoreDataToDoTask] = []
    
    private var filteredTasks: [CoreDataToDoTask] = [] {
        didSet {
            tableView.reloadData()
            countOfTasks.text = "\(self.filteredTasks.count) задач"
        }
    }
    
    private var currentSearchText: String = ""
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .searchGray
        searchBar.searchTextField.layer.cornerRadius = 8
        searchBar.searchTextField.layer.masksToBounds = true
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayColour6,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        )
        
        searchBar.searchTextField.leftView?.tintColor = .grayColour6
        searchBar.searchTextField.textColor = .white
        
        return searchBar
    }()
    
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        refreshControl.addTarget(self,
                                 action: #selector(refreshPage),
                                 for: .valueChanged)
        refreshControl.tintColor = .update
        table.refreshControl = refreshControl
        table.register(MainCell.self,
                       forCellReuseIdentifier: MainCell.cellId)
        table.backgroundColor = .black
        table.delegate = self
        table.dataSource = self
        return table
    }()
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "file_add"), for: .normal)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(goToCreate), for: .touchUpInside)
        return button
    }()
    private lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = .searchGray
        return view
    }()
    
    private lazy var countOfTasks: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .grayColour6
        label.numberOfLines = 0
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoaded()
    }
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubviews(searchBar,
                         tableView,
                         mainLabel,
                         grayView,
                         createButton,
                         countOfTasks)
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.left.equalToSuperview().offset(10)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.height.equalTo(36)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(grayView.snp.top)
        }
        grayView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(83)
            make.right.left.equalToSuperview()
        }
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
            make.width.equalTo(68)
            make.right.equalToSuperview()
        }
        countOfTasks.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15.5)
            make.centerX.equalToSuperview()
        }
    }
}


extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MainCell.cellId,
            for: indexPath) as! MainCell
        cell.configure(model: filteredTasks[indexPath.row])
        cell.tapAction = { [weak self] in
            guard let self else { return }
            self.presenter?.taskWillDone(task: self.filteredTasks[indexPath.row])
        }
        cell.deleteAction = { [weak self] in
            guard let self else { return }
            self.presenter?.taskWillDelete(task: self.filteredTasks[indexPath.row])
        }
        cell.shareAction = { [weak self] in
            guard let self else { return }
            self.shareTask(self.filteredTasks[indexPath.row])
        }
        cell.editAction = { [weak self] in
            guard let self else { return }
            let todo = filteredTasks[indexPath.row]
            self.presenter?.showTaskDetail(id: todo.id)
        }
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
}

extension MainVC: MainViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func changeTasks(tasks: [CoreDataToDoTask]) {
        self.allTasks = tasks
        applyFilter()
    }
    
    func showErrorMessage() {
        showErrorMessage(messageType: .error, "")
    }
}

//MARK: Actions
extension MainVC {
    @objc private func goToCreate() {
        presenter?.createTask()
    }
    @objc private func refreshPage() {
        presenter?.viewDidLoaded()
        refreshControl.endRefreshing()
    }
    private func applyFilter() {
        if currentSearchText.isEmpty {
            filteredTasks = allTasks
        } else {
            filteredTasks = allTasks.filter { task in
                guard let todo = task.todo else { return false }
                return todo.lowercased().contains(currentSearchText.lowercased())
            }
        }
    }
}

//MARK: Поиск
extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchText = searchText
        applyFilter()
    }
}

//MARK: Поделиться
extension MainVC {
    func shareTask(_ task: CoreDataToDoTask) {
        var itemsToShare = [Any]()
        
        if let todoText = task.todo {
            itemsToShare.append(todoText)
        }
        
        if let descriptionText = task.descrip {
            itemsToShare.append(descriptionText)
        }
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
}
