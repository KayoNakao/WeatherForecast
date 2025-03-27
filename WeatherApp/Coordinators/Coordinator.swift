//
//  Coordinator.swift
//  Weather
//
//  Created by Kayo on 2025-03-27.
//

import Foundation

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

public extension Coordinator {

    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }

    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}
