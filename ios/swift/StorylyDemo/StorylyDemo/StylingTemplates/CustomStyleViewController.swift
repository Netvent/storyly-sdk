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

    let customStorylyView1 = StorylyView()
    let customStorylyView2 = StorylyView()
    let customStorylyView3 = StorylyView()
    let customStorylyView4 = StorylyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // Do any additional setup after loading the view
        customStorylyView1.translatesAutoresizingMaskIntoConstraints = false

        customStorylyView1.storylyInit = StorylyInit(storylyId: STORYLY_DEFAULT_TOKEN)
        customStorylyView1.rootViewController = self
        customStorylyView1.storyGroupViewFactory = factory1
        self.view.addSubview(customStorylyView1)

        customStorylyView1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customStorylyView1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            customStorylyView1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        }
        customStorylyView1.heightAnchor.constraint(equalToConstant: 178).isActive = true
        
        
        customStorylyView2.translatesAutoresizingMaskIntoConstraints = false

        customStorylyView2.storylyInit = StorylyInit(storylyId: STORYLY_DEFAULT_TOKEN)
        customStorylyView2.rootViewController = self
        customStorylyView2.storyGroupViewFactory = factory2
        self.view.addSubview(customStorylyView2)

        customStorylyView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customStorylyView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customStorylyView2.topAnchor.constraint(equalTo: self.customStorylyView1.bottomAnchor, constant: 5).isActive = true
        
        customStorylyView2.heightAnchor.constraint(equalToConstant: 178).isActive = true
        
        customStorylyView3.translatesAutoresizingMaskIntoConstraints = false

        customStorylyView3.storylyInit = StorylyInit(storylyId: STORYLY_DEFAULT_TOKEN)
        customStorylyView3.rootViewController = self
        customStorylyView3.storyGroupViewFactory = factory3
        self.view.addSubview(customStorylyView3)

        customStorylyView3.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customStorylyView3.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customStorylyView3.topAnchor.constraint(equalTo: self.customStorylyView2.bottomAnchor, constant: 5).isActive = true
        
        customStorylyView3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        customStorylyView4.translatesAutoresizingMaskIntoConstraints = false

        customStorylyView4.storylyInit = StorylyInit(storylyId: STORYLY_DEFAULT_TOKEN)
        customStorylyView4.rootViewController = self
        customStorylyView4.storyGroupViewFactory = factory4
        self.view.addSubview(customStorylyView4)

        customStorylyView4.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customStorylyView4.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customStorylyView4.topAnchor.constraint(equalTo: self.customStorylyView3.bottomAnchor, constant: 5).isActive = true
        
        customStorylyView4.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

extension CustomStyleViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup]) {
        print("storylyLoaded \(storyGroupList.count)")
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyLoadFailed:\(errorMessage)")
    }

    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) {
        print("storylyActionClicked:\(story)")
    }
    
    func storylyStoryPresented(_ storylyView: StorylyView) {
        print("storylyStoryPresented")
    }
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {
        print("storylyStoryDismissed")
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {
        print("storylyStoryLayerInteracted")
    }
    
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
        print("storylyEvent:\(event.rawValue):\(event.stringValue):\(storyGroup?.id):\(story?.id):\(storyComponent?.type)")
    }
}
