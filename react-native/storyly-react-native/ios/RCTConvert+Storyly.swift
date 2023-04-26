//
//  RCTConvert+Storyly.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//
import Storyly

@objc(StorylyBundle)
class StorylyBundle: NSObject {
    let storylyView: StorylyView
    let storyGroupViewFactory: STStoryGroupViewFactory?
    
    init(storylyView: StorylyView,
         storyGroupViewFactory: STStoryGroupViewFactory?) {
        self.storylyView = storylyView
        self.storyGroupViewFactory = storyGroupViewFactory
    }
}

extension RCTConvert {
    @objc(stStorylyBundle:)
    static func stStorylyBundle(json: NSDictionary) -> StorylyBundle? {
        print("STR:RCTConvert+Extension:stStorylyBundle(json:\(json))")
        guard let storylyInitJson = json["storylyInit"] as? NSDictionary else { return nil }
        guard let storyGroupIconStylingJson = json["storyGroupIconStyling"] as? NSDictionary else { return nil }
        guard let storyGroupViewFactoryJson = json["storyGroupViewFactory"] as? NSDictionary else { return nil }
        guard let storyGroupListStylingJson = json["storyGroupListStyling"] as? NSDictionary else { return nil }
        guard let storyGroupTextStylingJson = json["storyGroupTextStyling"] as? NSDictionary else { return nil }
        guard let storyHeaderStylingJson = json["storyHeaderStyling"] as? NSDictionary else { return nil }
        
        var storyGroupViewFactory: STStoryGroupViewFactory? = nil
        
        let storylyView = StorylyView()
        storylyView.storylyInit = stStorylyInit(json: storylyInitJson)
        storylyView.storylyShareUrl = json["storylyShareUrl"] as? String

        if let storyGroupViewFactorySize = stStoryGroupViewFactorySize(json: storyGroupViewFactoryJson) {
            storyGroupViewFactory = STStoryGroupViewFactory(width: storyGroupViewFactorySize.width,
                                                            height: storyGroupViewFactorySize.height)
        } else {
            storylyView.storyGroupSize = json["storyGroupSize"] as? String ?? "large"
            storylyView.storyGroupIconStyling = stStoryGroupIconStyling(json: storyGroupIconStylingJson)
            storylyView.storyGroupTextStyling = stStoryGroupTextStyling(json: storyGroupTextStylingJson)
            if let storyGroupIconBorderColorSeenJson = json["storyGroupIconBorderColorSeen"] as? NSArray {
                storylyView.storyGroupIconBorderColorSeen = RCTConvert.uiColorArray(storyGroupIconBorderColorSeenJson)
            }
            if let storyGroupIconBorderColorNotSeenJson = json["storyGroupIconBorderColorNotSeen"] as? NSArray {
                storylyView.storyGroupIconBorderColorNotSeen = RCTConvert.uiColorArray(storyGroupIconBorderColorNotSeenJson)
            }
            if let storyGroupIconBackgroundColorJson = json["storyGroupIconBackgroundColor"] as? NSNumber {
                storylyView.storyGroupIconBackgroundColor = RCTConvert.uiColor(storyGroupIconBackgroundColorJson)
            }
            if let storyGroupPinIconColorJson = json["storyGroupPinIconColor"] as? NSNumber {
                storylyView.storyGroupPinIconColor = RCTConvert.uiColor(storyGroupPinIconColorJson)
            }
            storylyView.storyGroupAnimation = json["storyGroupAnimation"] as? String ?? "border-rotation"
        }
        storylyView.storyGroupListStyling = stStoryGroupListStyling(json: storyGroupListStylingJson)
        if stStorylyLayoutDirection(direction: (json["storylyLayoutDirection"] as? String) ?? "ltr") == .RTL {
            storylyView.storylyLayoutDirection = .RTL
        }
        
        storylyView.storyHeaderStyling = stStoryHeaderStyling(json: storyHeaderStylingJson)
        if let storyItemTextColorJson = json["storyItemTextColor"] as? NSNumber {
            storylyView.storyItemTextColor = RCTConvert.uiColor(storyItemTextColorJson)
        }
        if let storyItemIconBorderColorJson = json["storyItemIconBorderColor"] as? NSNumber {
            storylyView.storyItemIconBorderColor = RCTConvert.uiColorArray(storyItemIconBorderColorJson)
        }
        if let storyItemProgressBarColorJson = json["storyItemProgressBarColor"] as? NSNumber {
            storylyView.storylyItemProgressBarColor = RCTConvert.uiColorArray(storyItemProgressBarColorJson)
        }
        storylyView.storyItemTextFont = getCustomFont(typeface: json["storyItemTextTypeface"] as? NSString, fontSize: 14, defaultWeight: .semibold)
        storylyView.storyInteractiveFont = getCustomFont(typeface: json["storyInteractiveTextTypeface"] as? NSString, fontSize: 14, defaultWeight: .regular)
        
        return StorylyBundle(storylyView: storylyView, storyGroupViewFactory: storyGroupViewFactory)
    }
}

private func stStorylyInit(json: NSDictionary) -> StorylyInit {
    var segmentation: StorylySegmentation = StorylySegmentation(segments: nil)
    if let segmentsData = json["storylySegments"] as? [String] {
        segmentation = StorylySegmentation(segments: Set(segmentsData))
    }
    
    return StorylyInit(
        storylyId: (json["storylyId"] as? String) ?? "",
        segmentation: segmentation,
        customParameter: json["customParameter"] as? String,
        isTestMode: (json["storylyIsTestMode"] as? Bool) ?? false,
        storylyPayload: json["storylyPayload"] as? String,
        userData: json["userProperty"] as? [String: String] ?? [:]
    )
}

private func stStoryGroupListStyling(json: NSDictionary) -> StoryGroupListStyling {
    var orientation: StoryGroupListOrientation
    switch json["orientation"] as? String {
        case "horizontal": orientation = .Horizontal
        case "vertical": orientation = .Vertical
        default: orientation = .Horizontal
    }

    let sections = (json["sections"] as? Int) ?? 1
    let horizontalEdgePadding = (json["horizontalEdgePadding"] as? CGFloat) ?? 4
    let verticalEdgePadding = (json["verticalEdgePadding"] as? CGFloat) ?? 4
    let horizontalPaddingBetweenItems = (json["horizontalPaddingBetweenItems"] as? CGFloat) ?? 8
    let verticalPaddingBetweenItems = (json["verticalPaddingBetweenItems"] as? CGFloat) ?? 8

    let storylyGroupListStyling = StoryGroupListStyling(
        orientation: orientation,
        sections: sections,
        horizontalEdgePadding: horizontalEdgePadding,
        verticalEdgePadding: verticalEdgePadding,
        horizontalPaddingBetweenItems: horizontalPaddingBetweenItems,
        verticalPaddingBetweenItems: verticalPaddingBetweenItems
    )
    return storylyGroupListStyling
}

private func stStoryGroupIconStyling(json: NSDictionary) -> StoryGroupIconStyling {
    let height = (json["height"] as? CGFloat) ?? 80
    let width = (json["width"] as? CGFloat) ?? 80
    let cornerRadius = (json["cornerRadius"] as? CGFloat) ?? 40
    return StoryGroupIconStyling(height: height, width: width, cornerRadius: cornerRadius)
}

private func stStoryGroupViewFactorySize(json: NSDictionary) -> CGSize? {
    let width = (json["width"] as? CGFloat) ?? 0
    let height = (json["height"] as? CGFloat) ?? 0
    let factorySize = CGSize(width: width, height: height)
    return factorySize == .zero ? nil : factorySize
}

private func stStoryGroupTextStyling(json: NSDictionary) -> StoryGroupTextStyling {
    let isVisible = (json["isVisible"] as? Bool) ?? true
    let textColorSeen = UIColor(hexString: (json["colorSeen"] as? String)) ?? .black
    let textColorNotSeen = UIColor(hexString: (json["colorNotSeen"] as? String)) ?? .black
    
    let fontSize = (json["textSize"] as? Int) ?? 12
    let font = getCustomFont(typeface: (json["typeface"] as? NSString), fontSize: CGFloat(fontSize))
    let lines = (json["lines"] as? Int) ?? 2
    
    return StoryGroupTextStyling(isVisible: isVisible,
                                 colorSeen: textColorSeen,
                                 colorNotSeen: textColorNotSeen,
                                 font: font,
                                 lines: lines)
}

private func stStorylyLayoutDirection(direction: String) -> StorylyLayoutDirection {
    switch direction {
        case "ltr": return .LTR
        case "rtl": return .RTL
        default: return .LTR
    }
}

private func stStoryHeaderStyling(json: NSDictionary) -> StoryHeaderStyling {
    let isTextVisible = (json["isTextVisible"] as? Bool) ?? true
    let isIconVisible = (json["isIconVisible"] as? Bool) ?? true
    let isCloseButtonVisible = (json["isCloseButtonVisible"] as? Bool) ?? true
    
    let closeIconImage = UIImage(named: (json["closeIcon"] as? String))
    let shareIconImage = UIImage(named: (json["shareIcon"] as? String))
    
    return StoryHeaderStyling(isTextVisible: isTextVisible,
                              isIconVisible: isIconVisible,
                              isCloseButtonVisible: isCloseButtonVisible,
                              closeButtonIcon: closeIconImage,
                              shareButtonIcon: shareIconImage)
}

private func getCustomFont(typeface: NSString?, fontSize: CGFloat, defaultWeight: UIFont.Weight = .regular) -> UIFont {
    if let fontName = typeface?.deletingPathExtension,
       let font = UIFont(name: fontName, size: fontSize) { return font }
    return .systemFont(ofSize: fontSize, weight: defaultWeight)
}

internal extension UIImage {
    convenience init?(named: String?) {
        guard let named = named else { return nil }
        self.init(named: named)
    }
}

internal extension UIColor {
    convenience init?(hexString: String?) {
        guard let hexString = hexString else { return nil }

        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 1
        scanner.scanHexInt64(&hexNumber)
        
        let red, green, blue, alpha: CGFloat
        if hexString.count == 9 {
            alpha = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            red = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            blue = CGFloat(hexNumber & 0x000000ff) / 255
        } else {
            red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            blue = CGFloat(hexNumber & 0x0000ff) / 255
            alpha = 1
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
