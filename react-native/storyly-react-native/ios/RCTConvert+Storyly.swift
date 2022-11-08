//
//  RCTConvert+Storyly.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//
import Storyly

extension RCTConvert {
    @objc(stStorylyInit:)
    static func stStorylyInit(json: NSDictionary) -> StorylyInit {
        var segmentation: StorylySegmentation? = nil
        if let segmentsData = json["storylySegments"] as? Set<String> {
            segmentation = StorylySegmentation(segments: segmentsData)
        }
        
        let isTestMode = (json["storylyIsTestMode"] as? Bool) ?? false
        
        let storylyInit = StorylyInit(storylyId: (json["storylyId"] as? String) ?? "",
                                      segmentation: segmentation ?? StorylySegmentation(segments: nil),
                                      customParameter: json["customParameter"] as? String,
                                      isTestMode: isTestMode,
                                      storylyPayload: json["storylyPayload"] as? String,
                                      userData: json["userProperty"] as? [String: String] ?? [:])
        return storylyInit
    }

    @objc(stStoryGroupListStyling:)
    static func stStoryGroupListStyling(json: NSDictionary) -> StoryGroupListStyling {
        let edgePadding = (json["edgePadding"] as? CGFloat) ?? 4
        let paddingBetweenItems = (json["paddingBetweenItems"] as? CGFloat) ?? 8
        return StoryGroupListStyling(edgePadding: edgePadding, paddingBetweenItems: paddingBetweenItems)
    }
    
    @objc(stStoryGroupIconStyling:)
    static func stStoryGroupIconStyling(json: NSDictionary) -> StoryGroupIconStyling {
        let height = (json["height"] as? CGFloat) ?? 80
        let width = (json["width"] as? CGFloat) ?? 80
        let cornerRadius = (json["cornerRadius"] as? CGFloat) ?? 40
        return StoryGroupIconStyling(height: height, width: width, cornerRadius: cornerRadius)
    }
    
    @objc(stStoryGroupTextStyling:)
    static func stStoryGroupTextStyling(json: NSDictionary) -> StoryGroupTextStyling {
        let isVisible = (json["isVisible"] as? Bool) ?? true
        let textColorSeen = UIColor(hexString: (json["colorSeen"] as? String)) ?? .black
        let textColorNotSeen = UIColor(hexString: (json["colorNotSeen"] as? String)) ?? .black
        
        let fontSize = (json["textSize"] as? Int) ?? 12
        let font = getCustomFont(typeface: (json["typeface"] as? NSString), fontSize: CGFloat(fontSize))
        let lines = (json["lines"] as? Int) ?? 2
        
        let storyGroupTextStyling = StoryGroupTextStyling(isVisible: isVisible, colorSeen: textColorSeen,
                                                          colorNotSeen: textColorNotSeen, font: font, lines: lines)
        return storyGroupTextStyling
    }
    
    @objc(stStoryHeaderStyling:)
    static func stStoryHeaderStyling(json: NSDictionary) -> StoryHeaderStyling {
        let isTextVisible = (json["isTextVisible"] as? Bool) ?? true
        let isIconVisible = (json["isIconVisible"] as? Bool) ?? true
        let isCloseButtonVisible = (json["isCloseButtonVisible"] as? Bool) ?? true
        
        let closeIconImage = UIImage(named: (json["closeIcon"] as? String))
        let shareIconImage = UIImage(named: (json["shareIcon"] as? String))
        
        let storyHeaderStyling = StoryHeaderStyling(isTextVisible: isTextVisible, isIconVisible: isIconVisible,
                                                    isCloseButtonVisible: isCloseButtonVisible,
                                                    closeButtonIcon: closeIconImage, shareButtonIcon: shareIconImage)
        return storyHeaderStyling
    }
    
    @objc(stStoryGroupViewFactory:)
    static func stStoryGroupViewFactory(json: NSDictionary?) -> CGSize {
        let width = (json?["width"] as? CGFloat) ?? 0
        let height = (json?["height"] as? CGFloat) ?? 0
        return CGSize(width: width, height: height)
    }
    
    @objc(stStorylyLayoutDirection:)
    static func stStorylyLayoutDirection(direction: NSString) -> StorylyLayoutDirection {
        switch direction {
            case "ltr": return .LTR
            case "rtl": return .RTL
            default: return .LTR
        }
    }
    
    @objc(stStoryItemTextTypeface:)
    static func stStoryItemTextTypeface(typeface: NSString) -> UIFont {
        return getCustomFont(typeface: typeface, fontSize: 14, defaultWeight: .semibold)
    }
    
    @objc(stStoryInteractiveTextTypeface:)
    static func stStoryInteractiveTextTypeface(typeface: NSString) -> UIFont {
        return getCustomFont(typeface: typeface, fontSize: 14, defaultWeight: .regular)
    }
    
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
