//
//  ViewController.swift
//  MomentsDemo
//
//  Created by Yiğit Çalışkan on 21.09.2022.
//

import UIKit
import Storyly
import StorylyMoments

let STORYLY_INSTANCE_TOKEN = ""
let MOMENTS_INSTANCE_TOKEN = ""
let ENCRYPTED_USER_PAYLOAD = ""

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let storylyView = StorylyView()
        storylyView.translatesAutoresizingMaskIntoConstraints = false
        storylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN, storylyPayload: ENCRYPTED_USER_PAYLOAD)
        storylyView.rootViewController = self
        storylyView.delegate = self
        storylyView.momentsDelegate = self
        
        let storylyMoments = StorylyMomentsManager(config: Config(momentsToken: MOMENTS_INSTANCE_TOKEN, userPayload: ENCRYPTED_USER_PAYLOAD))
        storylyMoments.rootViewController = self
        storylyMoments.momentsDelegate = self
        
        self.view.addSubview(storylyView)
        storylyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        storylyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        storylyView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        storylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
}

extension ViewController: StorylyMomentsDelegate {
    func storyHeaderClicked(_ storylyView: StorylyView, storyGroup: StoryGroup?, story: Story?) {}
}

extension ViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                       storyGroupList: [Storyly.StoryGroup],
                       dataSource: StorylyDataSource) {}

    func storylyLoadFailed(_ storylyView: Storyly.StorylyView,
                           errorMessage: String) {}

    func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                              rootViewController: UIViewController,
                              story: Storyly.Story) {}

    func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {}
    
    func storylyStoryPresentFailed(_ storylyView: StorylyView,
                                   errorMessage: String) {}

    func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {}

    func storylyUserInteracted(_ storylyView: Storyly.StorylyView,
                               storyGroup: Storyly.StoryGroup,
                               story: Storyly.Story,
                               storyComponent: Storyly.StoryComponent) {}

    func storylyEvent(_ storylyView: Storyly.StorylyView,
                      event: Storyly.StorylyEvent,
                      storyGroup: Storyly.StoryGroup?,
                      story: Storyly.Story?,
                      storyComponent: Storyly.StoryComponent?) {
        print("Event: \(event.stringValue), story group: \(storyGroup?.title)")
    }
}

extension ViewController: MomentsDelegate {
    
    func onUserStoriesLoaded(storyGroup: MomentsStoryGroup?) {}
    
    func onUserStoriesLoadFailed(errorMessage: String) {}
    
    func onOpenMyStory() {}
    
    func onOpenCreateStory(isDirectMediaUpload: Bool) {}

    func onUserActionClicked(story: MomentsStory) {}
    
    func onPreModeration(texts: [String]?, onCompletion: ((Bool, String?) -> Void)?) {}
    
    func storylyMomentsEvent(event: StorylyMomentsEvent, storyGroup: MomentsStoryGroup?, stories: [MomentsStory]?) {}
}


