//
//  IntegrationViewController.swift
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 5.02.2022.
//  Copyright © 2022 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

let STORYLY_DEMO_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjEwNDA5fQ.kXqBdpUcKaJe7eA98PqHahMDf-123Uhb82t_mYzbBUM"

class IntegrationViewController: UIViewController {

    @IBOutlet weak var storylyView: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storylyView.storylyInit = StorylyInit(storylyId: STORYLY_DEMO_TOKEN)
        storylyView.rootViewController = self
        storylyView.delegate = self
    }
    
    private func segueFromActionUrl(url: String?) -> String? {
        guard let url = url,
              let actionUrl = URL(string: url) else { return nil }
        guard actionUrl.scheme == "app" && actionUrl.host == "storyly-demo" else { return nil }
        let segueId = actionUrl.path
        return isSegueFound(withIdentifier: segueId) ? segueId : nil
    }
    
    private func isSegueFound(withIdentifier id: String) -> Bool {
        guard let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        return segues.first { $0.value(forKey: "identifier") as? String == id } != nil
    }
}

extension IntegrationViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup], dataSource: StorylyDataSource) {
        print("[storyly] IntegrationViewController:storylyLoaded - storyGroupList size {\(storyGroupList.count)} - source {\(dataSource)}")
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        print("[storyly] IntegrationViewController:storylyLoadFailed - error {\(errorMessage)}")
    }
    
    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) {
        print("[storyly] IntegrationViewController:storylyActionClicked - story action_url {\(story.media.actionUrl ?? "")}")
        guard let segueId = segueFromActionUrl(url: story.media.actionUrl) else {
            print("[storyly] action_url not valid")
            return
        }
        storylyView.dismiss(animated: true)
        performSegue(withIdentifier: segueId, sender: self)
    }
}
