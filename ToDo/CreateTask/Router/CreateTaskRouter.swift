//
//  CreateTaskRouter.swift
//  ToDo
//
//  Created by Abylaikhan Abilkayr on 28.08.2024.
//

import Foundation
import UIKit

protocol CreateTaskRouterProtocol: AnyObject {
    func dismiss()
}

class CreateTaskRouter: CreateTaskRouterProtocol {
    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
