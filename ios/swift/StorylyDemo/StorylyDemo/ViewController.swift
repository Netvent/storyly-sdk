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
    private var customLoadingView = CustomLoadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.storylyView.storylyInit = StorylyInit(storylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
        self.storylyView.rootViewController = self
        self.storylyView.delegate = self
        // If you want your own loading view uncomment and edit the following lines
//        self.storylyView.storylyLoadingView = customLoadingView
    }
}

extension ViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup]) {
        print("storylyLoaded")
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyLoadFailed")
    }
    
    func storylyActionClicked(_ storylyView: Storyly.StorylyView, rootViewController: UIViewController, story: Storyly.Story) -> Bool {
        print("storylyActionClicked")
        
        // Edit and use the following method to open an external custom view
//        self.showCustomExternalView(storylyView: storylyView, story: story)
        
        return true // return false if sdk should handle click
    }
    
    func storylyStoryPresented(_ storylyView: StorylyView) {
        print("storylyStoryPresented")
    }
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {
        print("storylyStoryDismissed")
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {
        switch storyComponent.type {
            case .Quiz:
                if let quizComponent = storyComponent as? StoryQuizComponent {
                    // quizComponent actions
                }
            case .Poll:
                if let pollComponent = storyComponent as? StoryPollComponent {
                    // pollComponent actions
                }
            case .Emoji:
                if let emojiComponent = storyComponent as? StoryEmojiComponent {
                    // emojiComponent actions
                }
            case .Undefined: do {}
            default: do {}
        }
    }
}
