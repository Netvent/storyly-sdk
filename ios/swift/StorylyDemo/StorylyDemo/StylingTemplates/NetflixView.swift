//
//  NetflixView.swift
//  StorylyDemo
//
//  Created by Haldun  Fadillioglu on 23.11.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly


public class NetflixView: StoryGroupView {
    
    let kCONTENT_XIB_NAME = "NetflixView"
    

    @IBOutlet weak var groupIcon: UIRoundImageView!
    @IBOutlet weak var pinIcon: UIRoundImageView!
    @IBOutlet weak var vodIcon: UIRoundImageView!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet var contentView: UIView!

    private let defaultBorderColor = [
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
        contentView.frame = self.bounds
    }
    
    public override func populateView(storyGroup: StoryGroup?) {
        if let storyGroup = storyGroup {
            //  In storyly dashboard, update story group title giving a parameter (that would not affect normal texts)
            //  that will programmatically update border color with custom factory.
            //  For example:
            //    - Add parameters to title, such as {r}, {g}, {b} to understand which predefined border color to use
            //    - Check and remove before setting to groupTitle
            let (title, borderColor) = customBorderColor(storyGroupTitle: storyGroup.title)
            
            self.groupTitle.text = title
            self.groupIcon.setImage(iconUrl: storyGroup.iconUrl!, contentMode: .scaleAspectFill)
            self.pinIcon.isHidden = storyGroup.pinned ? false : true
            self.vodIcon.isHidden = storyGroup.type == .IVod ? false : true

            self.groupIcon.borderColor =  borderColor ?? defaultBorderColor

        } else {
            self.groupTitle.text = ""
            self.groupIcon.borderColor = [UIColor.clear, UIColor.clear]
            self.vodIcon.isHidden = true
            self.pinIcon.isHidden = true
            self.groupIcon.sd_cancelCurrentImageLoad()
        }
    }
    
    private func customBorderColor(storyGroupTitle: String) -> (String, [UIColor]?) {
        if storyGroupTitle.contains("{r}") {
            let cleanTitle = storyGroupTitle.replacingOccurrences(of: "{r}", with: "")
            let borderColors = [UIColor(red: 0.74, green: 0.09, blue: 0.10, alpha: 1.00), UIColor(red: 0.74, green: 0.09, blue: 0.10, alpha: 1.00)]
            return (cleanTitle, borderColors)
        } else if storyGroupTitle.contains("{g}") {
            let cleanTitle = storyGroupTitle.replacingOccurrences(of: "{g}", with: "")
            let borderColors = [UIColor(red: 0.09, green: 0.43, blue: 0.26, alpha: 1.00), UIColor(red: 0.09, green: 0.43, blue: 0.26, alpha: 1.00)]
            return (cleanTitle, borderColors)
        } else if storyGroupTitle.contains("{b}") {
            let cleanTitle = storyGroupTitle.replacingOccurrences(of: "{b}", with: "")
            let borderColors = [UIColor(red: 0.15, green: 0.45, blue: 0.85, alpha: 1.00), UIColor(red: 0.15, green: 0.45, blue: 0.85, alpha: 1.00)]
            return (cleanTitle, borderColors)
        }
        return (storyGroupTitle, nil)
    }
}

public class NetflixViewFactory: StoryGroupViewFactory {
    public func getSize() -> CGSize {
        return CGSize(width: 150, height: 180)
    }
    
    public func createView() -> StoryGroupView {
        return NetflixView(frame: .zero)
    }
}
