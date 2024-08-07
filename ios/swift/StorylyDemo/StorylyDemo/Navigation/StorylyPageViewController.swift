//
//  BasicViewController.swift
//  StorylyDemo
//
//  Created by Levent ORAL on 25.09.2019.
//  Copyright © 2019 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class StorylyPageViewController: UIViewController {

    @IBOutlet weak var storylyView: StorylyView!
    private var lastStorylyView: StorylyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        self.storylyView.rootViewController = self
        self.storylyView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail" {
             if let destinationVC = segue.destination as? DetailViewController {
                 destinationVC.onDismiss = { [weak self] in
                     self?.lastStorylyView?.resumeStory(animated: true)
                     self?.lastStorylyView = nil
                 }
             }
         }
     }
}

extension StorylyPageViewController: StorylyDelegate {
    func storylyActionClicked(
        _ storylyView: StorylyView,
        rootViewController: UIViewController,
        story: Story
    ) {
        lastStorylyView = storylyView
        lastStorylyView?.pauseStory(animated: true) {
            self.performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
}
