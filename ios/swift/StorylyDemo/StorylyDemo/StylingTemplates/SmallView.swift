//
//  SmallView.swift
//  StorylyDemo
//
//  Created by Haldun Fadillioglu on 20.09.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly


public class SmallView: StoryGroupView {
    
    let kCONTENT_XIB_NAME = "SmallView"
    

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupIcon: UIRoundImageView!
    @IBOutlet weak var pinIcon: UIRoundImageView!
    @IBOutlet weak var vodIcon: UIRoundImageView!
    @IBOutlet weak var contentView: UIView!
    
    private let colorsSeen = [
        UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1),
        UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
    ]
    
    private let colorsNotSeen = [
        UIColor(red: 1.00, green: 0.82, blue: 0.41, alpha: 1.0),
        UIColor(red: 0.98, green: 0.49, blue: 0.13, alpha: 1.0),
        UIColor(red: 0.79, green: 0.16, blue: 0.48, alpha: 1.0),
        UIColor(red: 0.59, green: 0.18, blue: 0.76, alpha: 1.0)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        addSubview(contentView)
        if let image = UIImage(named: "st_pin_icon", in: Bundle(for: StorylyView.self as AnyClass), compatibleWith: nil)?.imageWithInsets(insetDimen: 7) {
            pinIcon.setImage(image: image, contentMode: .scaleAspectFit)
        }
        if let image = UIImage(named: "st_ivod_icon", in: Bundle(for: StorylyView.self as AnyClass), compatibleWith: nil)?.imageWithInsets(insetDimen: 7) {
            vodIcon.setImage(image: image, contentMode: .scaleAspectFit)
        }
        groupTitle.numberOfLines = 0
        contentView.frame = self.bounds
    }
    
    public override func populateView(storyGroup: StoryGroup?) {
        if let storyGroup = storyGroup {
            self.groupTitle.text = storyGroup.title
            self.groupIcon.setImage(iconUrl: storyGroup.iconUrl, contentMode: .scaleAspectFill)
            self.pinIcon.isHidden = storyGroup.pinned ? false : true
            self.vodIcon.isHidden = storyGroup.type == .IVod ? false : true

            self.groupIcon.borderColor =  storyGroup.seen ? colorsSeen : colorsNotSeen

        } else {
            self.groupTitle.text = ""
            self.groupIcon.borderColor = [UIColor.clear, UIColor.clear]
            self.vodIcon.isHidden = true
            self.pinIcon.isHidden = true
            self.groupIcon.sd_cancelCurrentImageLoad()
        }
    }
    
}

public class SmallViewFactory: StoryGroupViewFactory {
    public func getSize() -> CGSize {
        return CGSize(width: 70, height: 110)
    }
    
    public func createView() -> StoryGroupView {
        return SmallView(frame: .zero)
    }
}
