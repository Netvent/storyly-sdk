//
//  EventHandlingViewController.swift
//  StorylyDemo
//
//  Created by Levent Oral on 8.02.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class EventHandlingViewController: UIViewController {
    
    @IBOutlet weak var storylyView: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.storylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        self.storylyView.rootViewController = self
        self.storylyView.delegate = self
    }
}

extension EventHandlingViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                       storyGroupList: [Storyly.StoryGroup]) {
    }

    func storylyLoadFailed(_ storylyView: Storyly.StorylyView,
                           errorMessage: String) {
    }

    func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                              rootViewController: UIViewController,
                              story: Storyly.Story) {
    }

    func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {
    }

    func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {
    }

    func storylyUserInteracted(_ storylyView: Storyly.StorylyView,
                               storyGroup: Storyly.StoryGroup,
                               story: Storyly.Story,
                               storyComponent: Storyly.StoryComponent) {
    }

    func storylyEvent(_ storylyView: Storyly.StorylyView,
                      event: Storyly.StorylyEvent,
                      storyGroup: Storyly.StoryGroup?,
                      story: Storyly.Story?,
                      storyComponent: Storyly.StoryComponent?) {
    }
}
