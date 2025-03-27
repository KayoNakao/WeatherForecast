//
//  HomeCoordinator.swift
//  Weather
//
//  Created by Kayo on 2025-03-27.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    
}

class HomeCoordinator: RootViewCoordinator {
    
    weak var delegate: HomeCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private lazy var navigationController: UINavigationController = {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        return navigationController
    }()
    
    func start() {}
    
}
