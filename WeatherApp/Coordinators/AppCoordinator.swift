//
//  AppCoordinator.swift
//  Weather
//
//  Created by Kayo on 2025-03-27.
//

import UIKit

public protocol RootViewControllerProvider: AnyObject {
    // The coordinators 'rootViewController'. It helps to think of this as the view controller that can be used to dismiss the coordinator from the view hierarchy.
    var rootViewController: UIViewController { get }
}

/// A Coordinator type that provides a root UIViewController
public typealias RootViewCoordinator = Coordinator & RootViewControllerProvider


class AppCoordinator: RootViewCoordinator {
    
    let window: UIWindow
    var childCoordinators: [Coordinator] = []
    private lazy var splashVC: SplashViewController = {
        let vc = SplashViewController()
        vc.delegate = self
        return vc
    }()
    
    private(set) var rootViewController: UIViewController = SplashViewController() {
        didSet {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = self.rootViewController
            })
        }
    }
    
    public init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
        self.window.makeKeyAndVisible()
    }
    
    private func setCurrentCoordinator(_ coordinator: RootViewCoordinator) {
        rootViewController = coordinator.rootViewController
    }
    
    func start() {
        window.rootViewController = splashVC
    }
}

extension AppCoordinator {
    
    func setupHome() {
        childCoordinators.removeAll()
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.delegate = self
        addChildCoordinator(homeCoordinator)
        setCurrentCoordinator(homeCoordinator)
    }

}

extension AppCoordinator: SplashViewControllerDelegate {
    func showHomeScreen() {
        setupHome()
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    
}
