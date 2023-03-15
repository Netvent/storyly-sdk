//
//  StorylyViewController.swift
//  SwiftUIDemo-Storyly
//
//  Created by appsamurai appsamurai on 14.03.2023.
//

import Foundation
import Storyly


class StorylyViewController: UIViewController {
    private var storylyView: StorylyView = {
        let storylyView = StorylyView()
        storylyView.translatesAutoresizingMaskIntoConstraints = false
        return storylyView
    }()
    
    internal func initStoryly(token: String) {
        storylyView.storylyInit = StorylyInit.init(storylyId: token)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storylyView.delegate = self
        self.storylyView.rootViewController = self
        view.addSubview(self.storylyView)
        NSLayoutConstraint.activate([
            storylyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storylyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storylyView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension StorylyViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup], dataSource: StorylyDataSource) {
        print("storylyLoaded:\(storyGroupList.count)")
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyLoadFailed:\(errorMessage)")
    }
    
    func storylyStoryShowFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyStoryShowFailed:\(errorMessage)")
    }
    
    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) {
        print("storylyActionClicked:\(story)")
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func storylyStoryPresented(_ storylyView: StorylyView) {
        print("storylyStoryPresented")
    }
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {
        print("storylyStoryDismissed")
    }
    
    func storylyStoryPresentFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("storylyStoryPresentFailed:\(errorMessage)")
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {
        print("storylyStoryLayerInteracted")
    }
    
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
        print("storylyEvent:\(event.rawValue):\(event.stringValue):\(storyGroup?.uniqueId):\(story?.uniqueId):\(storyComponent?.type)")
    }
}
