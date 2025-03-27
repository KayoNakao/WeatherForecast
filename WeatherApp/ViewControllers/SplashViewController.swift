//
//  SplashViewController.swift
//  Weather
//
//  Created by Kayo on 2025-03-27.
//

import UIKit

protocol SplashViewControllerDelegate: AnyObject {
    func showHomeScreen()
}

class SplashViewController: UIViewController {

    weak var delegate: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    func start() {
        self.delegate?.showHomeScreen()
    }
}
