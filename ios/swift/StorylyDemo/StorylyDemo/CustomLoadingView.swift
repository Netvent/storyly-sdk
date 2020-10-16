//
//  CustomLoadingView.swift
//  StorylyDemo
//
//  Created by Yiğit Çalışkan on 16.10.2020.
//  Copyright © 2020 App Samurai Inc. All rights reserved.
//

import Storyly
import NVActivityIndicatorView

class CustomLoadingView: UIView, StorylyLoadingView {
    
   private var activityIndicatorView: NVActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        let view = UIView(frame: frame)
        addSubview(view)

        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        activityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .blue, padding: 10)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)

        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true

    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func getView() -> UIView {
        return self
    }
    
    func show() {
        activityIndicatorView.startAnimating()
    }
    
    func hide() {
        activityIndicatorView.stopAnimating()
    }
}
