//
//  BaseViewController.swift
//  CoordinatorTemplate
//
//  Created by Kayo on 2025-03-27.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
            view.backgroundColor = .systemBackground
        }
        
}

extension BaseViewController {
    func presentErrorAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
        
        func presentErrorAlert(title: String, message: String, completion: @escaping () -> Void) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion()
                alert.dismiss(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
 
    func showLoadingView() {
            let loadingView = LoadingView(frame: view.frame)
            view.addSubview(loadingView)
            loadingView.tag = 20250900
        }
        
        func removeLoadingView() {
            if let loadingView = view.viewWithTag(20250900) {
                loadingView.removeFromSuperview()
            }
        }

}
