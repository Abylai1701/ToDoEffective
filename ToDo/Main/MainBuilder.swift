//
//  MainBuilder.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 27.08.2024.
//

import Foundation
import UIKit

class MainBuilder {
    static func build() -> UIViewController {
        let coreDataManager = CoreDataManager.shared
        let interactor = MainInteractor(coreStore: coreDataManager)
        let router = MainRouter()
        let presenter = MainPresenter(router: router, interactor: interactor)
        let vc = MainVC()
        vc.presenter = presenter
        presenter.view = vc
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}
