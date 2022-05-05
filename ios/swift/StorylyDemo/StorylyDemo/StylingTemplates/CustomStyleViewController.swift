//
//  CustomStyleViewController.swift
//  StorylyDemo
//
//  Created by Levent Oral on 9.08.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly
import SDWebImage

class CustomStyleViewController: UIViewController {
    
    private let gradientPortraitViewFactory: StoryGroupViewFactory = GradientPortraitViewFactory()
    private let portraitViewFactory: StoryGroupViewFactory = PortraitViewFactory()
    private let landspaceViewFactory: StoryGroupViewFactory = LandscapeViewFactory()
    private let wideLandspaceViewFactory: StoryGroupViewFactory = WideLandscapeViewFactory()
    private let smallViewFactory: StoryGroupViewFactory = SmallViewFactory()
    private let largeViewFactory: StoryGroupViewFactory = LargeViewFactory()
    private let titleParameterLargeViewFactory: StoryGroupViewFactory = TitleParameterLargeViewFactory()
    private let netflixViewFactory: StoryGroupViewFactory = NetflixViewFactory()

    @IBOutlet var gradientPortraitStorylyView: StorylyView!
    @IBOutlet var portraitStorylyView: StorylyView!
    @IBOutlet var landscapeStorylyView: StorylyView!
    @IBOutlet var wideLandscapeStorylyView: StorylyView!
    @IBOutlet var smallStorylyView: StorylyView!
    @IBOutlet var largeStorylyView: StorylyView!
    @IBOutlet var titleParameterLargeView: StorylyView!
    @IBOutlet weak var netflixStorylyView: StorylyView!
    
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // Do any additional setup after loading the view
        gradientPortraitStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        gradientPortraitStorylyView.rootViewController = self
        gradientPortraitStorylyView.storyGroupViewFactory = gradientPortraitViewFactory
        
        portraitStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        portraitStorylyView.rootViewController = self
        portraitStorylyView.storyGroupViewFactory = portraitViewFactory
        
        landscapeStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        landscapeStorylyView.rootViewController = self
        landscapeStorylyView.storyGroupViewFactory = landspaceViewFactory
        
        wideLandscapeStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        wideLandscapeStorylyView.rootViewController = self
        wideLandscapeStorylyView.storyGroupViewFactory = wideLandspaceViewFactory
        
        smallStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        smallStorylyView.rootViewController = self
        smallStorylyView.storyGroupViewFactory = smallViewFactory
        
        largeStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        largeStorylyView.rootViewController = self
        largeStorylyView.storyGroupViewFactory = largeViewFactory
        
        titleParameterLargeView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        titleParameterLargeView.rootViewController = self
        titleParameterLargeView.storyGroupViewFactory = titleParameterLargeViewFactory
        
        netflixStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        netflixStorylyView.rootViewController = self
        netflixStorylyView.storyGroupViewFactory = netflixViewFactory
    }
}
