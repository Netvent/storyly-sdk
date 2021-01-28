//
//  CustomSizeViewController.swift
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 28.01.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class CustomSizeViewController: UIViewController {
    @IBOutlet weak var storylyViewSmall: StorylyView!
    @IBOutlet weak var storylyViewLarge: StorylyView!
    @IBOutlet weak var storylyViewXLarge: StorylyView!
    @IBOutlet weak var storylyViewCustom: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storylyViewSmall.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        storylyViewSmall.rootViewController = self
        //storylyViewSmall.storyGroupSize = "small"
        
        storylyViewLarge.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        storylyViewLarge.rootViewController = self
        //storylyViewLarge.storyGroupSize = "large"
        
        storylyViewXLarge.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        storylyViewXLarge.rootViewController = self
        //storylyViewXLarge.storyGroupSize = "xlarge"
        
        storylyViewCustom.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        storylyViewCustom.rootViewController = self
        //storylyViewCustom.storyGroupSize = "custom"
        //storylyViewCustom.storyGroupIconStyling = StoryGroupIconStyling(height: 100, width: 150, cornerRadius: 15)
        // storylyViewCustom.storyGroupIconHeight = 100
        // storylyViewCustom.storyGroupIconWidth = 150
        // storylyViewCustom.storyGroupIconCornerRadius = 15
    }

}
