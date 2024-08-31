//
//  TaskDetailBuilder.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 30.08.2024.
//

import Foundation
import UIKit

class TaskDetailBuilder {
    static func build(id: Int64, delegate: CreateTaskDelegate?) -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let interactor = TaskDetailInteractor(coreStore: coreDataManager, id: id)
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(router: router, interactor: interactor)
        let vc = TaskDetailVC()
        vc.presenter = presenter
        presenter.view = vc
        presenter.delegate = delegate
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}
