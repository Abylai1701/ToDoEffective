//
//  CreateTaskBuilder.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 28.08.2024.
//

import Foundation
import UIKit

class CreateTaskBuilder {
    static func build(delegate: CreateTaskDelegate?) -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let interactor = CreateTaskInteractor(coreStore: coreDataManager)
        let router = CreateTaskRouter()
        let presenter = CreateTaskPresenter(router: router, interactor: interactor)
        let vc = CreateTaskVC()
        vc.presenter = presenter
        presenter.view = vc
        presenter.delegate = delegate
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}
