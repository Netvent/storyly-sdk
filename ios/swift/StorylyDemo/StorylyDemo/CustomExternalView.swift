//
//  CustomExternalView.swift
//  StorylyDemo
//
//  Created by Yiğit Çalışkan on 16.10.2020.
//  Copyright © 2020 App Samurai Inc. All rights reserved.
//

import Storyly

// Design your view as you want but the parent view will be resized to full screen
// Suggested usage is to use 'showExternalActionView()' in storylyActionClicked or storylyUserInteracted
extension ViewController {

    func showCustomExternalView(storylyView: StorylyView, story: Story) {
        let externalView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height / 2 - 50, width: 100, height: 100))
        externalView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)

        let externalButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 50, width: 200, height: 100))
        externalButton.backgroundColor = .gray
        externalButton.setTitle("Dismiss Story: \(story.id)", for: .normal)
        externalButton.addTarget(self, action: #selector(dismissExternalView(_:)), for: .touchUpInside)
        externalView.addSubview(externalButton)

        storylyView.showExternalActionView(externalActionView: externalView)
    }

    @objc func dismissExternalView(_ sender: UIButton) {
        self.storylyView.dismissExternalActionView()
    }
}
