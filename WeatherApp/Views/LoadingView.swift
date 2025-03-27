//
//  LoadingView.swift
//  CoordinatorTemplate
//
//  Created by Kayo on 2025-03-27.
//

import UIKit
import SnapKit

class LoadingView: UIView {

    private lazy var loadingView: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            return indicator
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configureLayout()
            loadingView.startAnimating()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureLayout() {
            backgroundColor = .black.withAlphaComponent(0.4)
            addSubview(loadingView)
            loadingView.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }

}
