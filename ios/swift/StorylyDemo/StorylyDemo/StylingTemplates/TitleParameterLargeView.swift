//
//  TitleParameterLargeView.swift
//  StorylyDemo
//
//  Created by Haldun Fadillioglu on 20.09.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly


public class TitleParameterLargeView: LargeView {
    
    private let parameterTestValue = "TestName"

    public override func populateView(storyGroup: StoryGroup?) {
        super.populateView(storyGroup: storyGroup)
        
        /*  In storyly dashboard, update story group name giving a parameter (that would not affect normal texts)
         *  that will be programmatically updated with custom factory.
         *  Example story group name from dashboard for parameter {a}:
         *      "Hello {a}"
         */
        guard let text = self.groupTitle.text else { return }
        self.groupTitle.text = text.replacingOccurrences(of: "{a}", with: "TestName")
    }
}

public class TitleParameterLargeViewFactory: LargeViewFactory {
    public override func createView() -> StoryGroupView {
        return TitleParameterLargeView(frame: .zero)
    }
}
