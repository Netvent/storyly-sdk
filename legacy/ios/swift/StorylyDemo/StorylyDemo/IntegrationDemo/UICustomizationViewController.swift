//
//  UICustomizationViewController.swift
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 5.02.2022.
//  Copyright © 2022 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class UICustomizationViewController: UIViewController {
    
    @IBOutlet weak var storylyView: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storylyView.rootViewController = self
    }
}
