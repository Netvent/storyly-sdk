//
//  ViewController.swift
//  StorylyDemo
//
//  Created by Levent ORAL on 25.09.2019.
//  Copyright © 2019 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class ViewController: UIViewController {

    @IBOutlet weak var storylyView: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.storylyView.appId = "[YOUR_APP_ID]"
        self.storylyView.rootViewController = self
        self.storylyView.delegate = self
    }
}

extension ViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView) {
        print("storylyLoaded")
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, error: StorylyError) {
        print("storylyLoadFailed \(error.localizedDescription)")
    }
}
