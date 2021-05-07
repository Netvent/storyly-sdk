//
//  ShowStorylyViewController.swift
//  StorylyDemo
//
//  Created by Haldun Fadillioglu on 3.05.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class ShowStorylyViewController: UIViewController {

    @IBOutlet weak var storylyHolder: UIStackView!
    var storylyView: StorylyView!
    
    var initialLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storylyView = StorylyView()
        storylyView.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40")
        storylyView.rootViewController = self
        storylyView.delegate = self
        
        addColoredViewWithConstraints(color: UIColor.red)
        addColoredViewWithConstraints(color: UIColor.blue)
        addColoredViewWithConstraints(color: UIColor.green)
        addColoredViewWithConstraints(color: UIColor.yellow)
    }
    
    private func addColoredViewWithConstraints(color: UIColor) {
        let view = UIView()
        view.backgroundColor = color
        storylyHolder.addArrangedSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: storylyHolder.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: storylyHolder.rightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }

}


extension ShowStorylyViewController: StorylyDelegate {

    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                       storyGroupList: [Storyly.StoryGroup]) {
        if initialLoad {
            initialLoad = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.addStorylyViewWithConstraints()
            }
        }
    }

    func storylyLoadFailed(_ storylyView: Storyly.StorylyView,
                           errorMessage: String) {
    }
    
    private func addStorylyViewWithConstraints() {
        self.storylyHolder.insertArrangedSubview(self.storylyView, at: 2)
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.leftAnchor.constraint(equalTo: self.storylyHolder.leftAnchor).isActive = true
        self.storylyView.rightAnchor.constraint(equalTo: self.storylyHolder.rightAnchor).isActive = true
        self.storylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
