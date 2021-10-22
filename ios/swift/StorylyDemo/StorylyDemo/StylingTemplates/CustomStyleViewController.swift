//
//  CustomStyleViewController.swift
//  StorylyDemo
//
//  Created by Levent Oral on 9.08.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class CustomStyleViewController: UIViewController {
    
    private let factory1: StoryGroupViewFactory = PortraitViewFactory()
    private let factory2: StoryGroupViewFactory = GradientPortraitViewFactory()
    private let factory3: StoryGroupViewFactory = LandscapeViewFactory()
    private let factory4: StoryGroupViewFactory = WideLandscapeViewFactory()

    @IBOutlet var gradientPortraitStorylyView: UIView!
    @IBOutlet var portraitStorylyView: UIView!
    @IBOutlet var landscapeStorylyView: UIView!
    @IBOutlet var wideLandscapeStorylyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // Do any additional setup after loading the view
        gradientPortraitStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        gradientPortraitStorylyView.rootViewController = self
        gradientPortraitStorylyView.storyGroupViewFactory = factory2
        
        portraitStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        portraitStorylyView.rootViewController = self
        portraitStorylyView.storyGroupViewFactory = factory1
        
        landscapeStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        landscapeStorylyView.rootViewController = self
        landscapeStorylyView.storyGroupViewFactory = factory3
        
        wideLandscapeStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        wideLandscapeStorylyView.rootViewController = self
        wideLandscapeStorylyView.storyGroupViewFactory = factory4
    }
}
