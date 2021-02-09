//
//  BasicViewController.swift
//  StorylyDemo
//
//  Created by Levent ORAL on 25.09.2019.
//  Copyright © 2019 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class BasicViewController: UIViewController {

    @IBOutlet weak var storylyView: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.storylyView.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40")
        self.storylyView.rootViewController = self
        
        let storylyViewProgrammatic = StorylyView()
        storylyViewProgrammatic.translatesAutoresizingMaskIntoConstraints = false
        storylyViewProgrammatic.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40")
        storylyViewProgrammatic.rootViewController = self
        self.view.addSubview(storylyViewProgrammatic)
        storylyViewProgrammatic.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        storylyViewProgrammatic.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        storylyViewProgrammatic.topAnchor.constraint(equalTo: self.storylyView.bottomAnchor, constant: 10).isActive = true
        storylyViewProgrammatic.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
