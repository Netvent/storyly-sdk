//
//  AdsViewController.swift
//  StorylyDemo
//
//  Created by Levent Oral on 27.07.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly
import StorylyMonetization

class AdsViewController: UIViewController {
    @IBOutlet weak var storylyView: StorylyView!
    
    private lazy var storylyAdViewProvider = StorylyAdViewProvider(rootViewController: self, adMobAdUnitId: ADMOB_NATIVE_AD_ID)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.storylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        self.storylyView.rootViewController = self
        self.storylyView.storylyAdViewProvider = self.storylyAdViewProvider
    }
}
