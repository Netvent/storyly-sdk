//
//  CustomThemeViewController.swift
//  StorylyDemo
//
//  Created by Haldun  Fadillioglu on 2.02.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class CustomThemeViewController: UIViewController {

    @IBOutlet weak var storylyViewDefaultTheme: StorylyView!
    @IBOutlet weak var storylyViewCustomTheme: StorylyView!

    override func viewDidLoad() {
        super.viewDidLoad()

        storylyViewDefaultTheme.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        storylyViewDefaultTheme.rootViewController = self
        
        storylyViewCustomTheme.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        storylyViewCustomTheme.rootViewController = self
        
//        storylyViewCustomTheme.storyGroupTextColor = UIColor(red: 240/255, green: 57/255, blue: 50/255, alpha: 1.0)
//
//        storylyViewCustomTheme.storyGroupIconBackgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)

        let seenBoder = [UIColor(red: 197/255, green: 172/255, blue: 165/255, alpha: 1.0), UIColor.black]
        storylyViewCustomTheme.storyGroupIconBorderColorSeen = seenBoder
        
        let notSeenBoder = [UIColor(red: 251/255, green: 50/255, blue: 0, alpha: 1.0),
                            UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1.0)]
        storylyViewCustomTheme.storyGroupIconBorderColorNotSeen = notSeenBoder
//        
//        storylyViewCustomTheme.storyGroupPinIconColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
//
//        storylyViewCustomTheme.storyItemTextColor = UIColor(red: 255/255, green: 0, blue: 87/255, alpha: 1.0)
//        
        let iconBorderColor = [UIColor(red: 251/255, green: 50/255, blue: 0, alpha: 1.0),
                               UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1.0)]
        storylyViewCustomTheme.storyItemIconBorderColor = iconBorderColor
//        
        let progressbarColor = [UIColor(red: 251/255, green: 50/255, blue: 0, alpha: 1.0),
                                UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1.0)]
        storylyViewCustomTheme.storylyItemProgressBarColor = progressbarColor
    }
}
