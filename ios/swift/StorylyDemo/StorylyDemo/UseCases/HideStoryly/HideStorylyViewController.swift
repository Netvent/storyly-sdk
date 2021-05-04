//
//  HideStorylyViewController.swift
//  StorylyDemo
//
//  Created by Haldun Fadillioglu on 3.05.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class HideStorylyViewController: UIViewController {

    @IBOutlet weak var storylyHolder: UIStackView!
    var storylyView: StorylyView!
    
    var initialLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let STORYLY_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"
       
        storylyView = StorylyView()
        storylyView.storylyInit = StorylyInit(storylyId: STORYLY_TOKEN)
        storylyView.rootViewController = self
        storylyView.delegate = self
        
        addColoredViewWithConstraints(color: UIColor.red)
        addColoredViewWithConstraints(color: UIColor.blue)
        addStorylyViewWithConstraints()
        addColoredViewWithConstraints(color: UIColor.green)
        addColoredViewWithConstraints(color: UIColor.yellow)
    }

    private func addStorylyViewWithConstraints() {
        self.storylyHolder.addArrangedSubview(self.storylyView)
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.leftAnchor.constraint(equalTo: self.storylyHolder.leftAnchor).isActive = true
        self.storylyView.rightAnchor.constraint(equalTo: self.storylyHolder.rightAnchor).isActive = true
        self.storylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
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


extension HideStorylyViewController: StorylyDelegate {

    func storylyLoaded(_ storylyView: Storyly.StorylyView, storyGroupList: [Storyly.StoryGroup]) {
        initialLoad = true
    }

    func storylyLoadFailed(_ storylyView: Storyly.StorylyView, errorMessage: String) {
        if !initialLoad {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.removeStorylyView()
            }
        }
    }
    
    private func removeStorylyView() {
        self.storylyHolder.removeArrangedSubview(self.storylyView)
        self.storylyView.isHidden = true
    }
}
