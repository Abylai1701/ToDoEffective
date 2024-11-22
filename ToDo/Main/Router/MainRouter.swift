//
//  MainRouter.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 26.08.2024.
//

import Foundation

protocol MainRouterProtocol: AnyObject {
    func createTask()
    func pushToDetail(id: Int64)
}

class MainRouter: MainRouterProtocol {
    weak var viewController: MainVC?
    
    func createTask() {
        let vc = CreateTaskBuilder.build(delegate: viewController?.presenter as? CreateTaskDelegate)
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        viewController?.present(vc, animated: true)
    }
    func pushToDetail(id: Int64) {
        let taskDetailVC = TaskDetailBuilder.build(id: id, delegate: viewController?.presenter as? CreateTaskDelegate)
        viewController?.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
