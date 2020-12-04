# Storyly 
Storyly SDK is used for story representation provided by App Samurai. You can register from [Storyly Dashboard](http://dashboard.storyly.io) and add stories to your registered applications and represent them in application with the help of this SDK.

Storyly SDK targets iOS 9 or higher. 
## Getting Started
Storyly SDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:
``` ruby
pod 'Storyly'
```
## Adding from Storyboard
StorylyView can be added to storyboard and xib file by defining `Custom Class` as StorylyView in `Identity Inspector`. In this approach, setting `width` to device’s `width` and `height`  to 120 is suggested for better experience for default size. If `small` size is selected for Storyly, then setting `height` to 90 is suggested.

## Adding Programmatically
```swift
let storylyView = StorylyView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 120))
self.view.addSubview(storylyView)
```
## Initialization
```swift
storylyView.storylyInit = StorylyInit(storylyId: [YOUR_APP_TOKEN_FROM_SETTINGS_SECTION_IN_DASHBOARD])
storylyView.rootViewController = self // A view controller
storylyView.delegate = self // StorylyDelegate implementation
```
## Storyly Initialization Parameters
Storyly can be customized based on your initialization parameters. Currently, StorylyInit class has the following definition:
```swift
init(storylyId: String, segmentation: StorylySegmentation, customParameter: String?)
```

#### Storyly Label Parameters
In StorylyInit class, "segments" parameter is related with the story group labels. In your storyly dashboard, if you set labels for your story groups you can use this parameter to only show these story groups. If label of the group group in dashboard is subset of your labels(segments) in SDK, SDK will show that story group. Here are a few examples: 
- If you do not give any parameters to "segments", SDK will show all active story groups with/without labels. This is the default behaviour.
- If you set ["car", "man"] as "segments" in SDK, Storyly SDK will show the story groups whose label set is "car", "man", car" and "man" and lastly it will show the story groups without labels. 
- If you set an empty "segments" in SDK, only the story groups without labels will be shown.

StorylySegmentation has the following definition:
```swift
init(segments: Set<String>? = nil, 
     isDynamicSegmentationEnabled: Bool = false, 
     dynamicSegmentationCallback: (StorylyDynamicSegmentationCallback? = nil) 
```
It is enough to set "segments" parameter to use label feature. All labels from SDK are case insensitive and trimmed. 

If you want to get information about what other parameters are please check Dynamic Label in [Advanced](#advanced) section.

#### Custom Parameter
In StorylyInit class, "customParameter" field can be used for analytical purposes. You can send a string value with this field which cannot have more than 200 characters. If you exceed the size limit, your value will be set to nil.

## Refresh
```swift
storylyView.refresh()
```

## Storyly Events
In Storyly, there are 5 different optional methods that you can use in an extension.  These are:
* storylyLoaded: This method is called when your story groups are loaded without a problem. It informs about loaded story groups and stories in them.
* storylyLoadFailed: This method is called if any problem occurs while loading story groups such as network problem etc… You can find detailed information from `errorMessage` parameter.
* storylyActionClicked: This method is called when the user clicks to action button on a story or swipes up in a story.  If you want to handle how the story link should be opened, you should override this method and you must return true as a result. Otherwise, SDK will open the link in a new activity. 
* storylyStoryPresented: This method is called when a story is shown in fullscreen.
* storylyStoryDismissed: This method is called when story screen is dismissed.
* storylyUserInteracted: This method is called when a user is interacted with a quiz, a poll or an emoji.
* storylyEvent: This method is called when a story event is occurred.

Sample usages can be seen below:
```swift
extension ViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup]) {}
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {}

    // return true if app wants to handle redirection, otherwise return false
    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) -> Bool {
        print("storylyActionClicked \(story)")
        return true
    }

    func storylyStoryPresented(_ storylyView: StorylyView) {}
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {}
    
    //StoryComponent can be one of the following subclasses: StoryEmojiComponent, StoryQuizComponent, StoryPollComponent. 
    //Based on "type" property of storyComponent, cast this argument to the proper subclass
    func storylyUserInteracted(_ storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {}

    func storylyEvent(_ storylyView: StorylyView,
                      event: StorylyEvent,
                      storyGroup: StoryGroup?,
                      story: Story?,
                      storyComponent: StoryComponent?) {}
}
```
As it can be seen from `storylyActionClicked` method, there is an object called `Story`. This object represents the story in which action is done and has some information about the story to be used. The structure of the `Story`, `StoryMedia`, `StorylyData` and `StoryType` objects are as follows. In addition, `storylyUserInteracted` method has a parameter called `StoryComponent` which has the following subclasses `StoryQuizComponent`, `StoryEmojiComponent`, `StoryPollComponent` with type class `StoryComponentType`, details of these object also can be seen below:

```swift
@objc public enum StoryType: Int {
    case Unknown
    case Image
    case Video
    case HTML
}

@objc public final class StoryGroup: NSObject {
    @objc public let id: Int
    @objc public let title: String
    @objc public let iconUrl: URL
    @objc public let index: Int
    @objc public let seen: Bool
    @objc public let stories: [Story]
}

@objc public final class Story: NSObject {
    @objc public let id: Int
    @objc public let title: String
    @objc public let index: Int
    @objc public let seen: Bool
    @objc public let media: StoryMedia
}

@objc public final class StoryMedia: NSObject {
    @objc public let type: StoryType
    @objc public let url: String
    @objc public var actionUrl: String?
}

@objc public class StoryComponent: NSObject {
    @objc public var type: StoryComponentType
}

@objc public enum StoryComponentType: Int {
    case Undefined
    case Quiz
    case Poll
    case Emoji
}

@objc public final class StoryQuizComponent: StoryComponent {
    @objc override public var type: StoryComponentType { return .Quiz }
    @objc public var title: String
    @objc public var options: [String]
    @objc public var rightAnswerIndex: NSNumber?
    @objc public var selectedOptionIndex: Int
    @objc public var customPayload: String?
}

@objc public final class StoryPollComponent: StoryComponent {
    @objc override public var type: StoryComponentType { return .Poll }
    @objc public var title: String
    @objc public var options: [String]
    @objc public var selectedOptionIndex: Int
    @objc public var customPayload: String?
}

@objc public final class StoryEmojiComponent: StoryComponent {
    @objc override public var type: StoryComponentType { return .Emoji }
    @objc public var emojiCodes: [String]
    @objc public var selectedEmojiIndex: Int
    @objc public var customPayload: String?
}

@objc public enum StorylyEvent: Int, RawRepresentable {
    case StoryGroupOpened
    case StoryGroupDeepLinkOpened
    case StoryGroupProgrammaticallyOpened
    case StoryGroupCompleted
    case StoryGroupPreviousSwiped
    case StoryGroupNextSwiped
    case StoryGroupClosed
    
    case StoryImpression
    case StoryCompleted
    case StoryPreviousClicked
    case StoryNextClicked
    case StoryPaused
    case StoryResumed
    case StoryShared
    
    case StoryCTAClicked
    case StoryEmojiClicked
    case StoryPollAnswered
    case StoryQuizAnswered
    case StoryCountdownReminderAdded
    case StoryCountdownReminderRemoved
    case StoryRated
    
    public var rawValue: String {
        return StorylyEventHelper.storylyEventName(event: self)
    }
}
``` 

## Third Party Library Integrations
In Storyly, you can use different story templates to show personalized products to your users if you are using one of the following personalization platforms. Currently, [Segmentify](https://www.segmentify.com/) is supported. Please check `Storyly External Data Flow` in [Advanced](#advanced) section in order to learn how to use these third party libraries.

#### Segmentify:
If you are planning to use Segmentify story group, please make sure you initialize Segmentify before Storyly initialization. Then, you can create different template stories from dashboard which has a Segmentify source. For more details on Segmentify integration: https://segmentify.github.io/segmentify-dev-doc/integration_ios/

## UI Customizations
Using Storyly SDK, you can customize story experience of your users. If you don’t specify any of these attributes, default values will be used. Some of color related attributes are single color attributes and others requires at least two colors. 

Here is the list of attributes that you can change:
####  ***Story Group Text Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor_1.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor.png)

This attribute changes the text color of the story group. This attribute can be specified programmatically or from attributes inspector of design view. 
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyGroupTextColor = UIColor
```
    
In order to set this attribute from design view, change the color of the `Story Group Text Color` under Storyly View section in attributes inspector.


#### ***Story Group Icon Background Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground_1.png)

This attribute changes the background color of the story group icon which is shown to the user as skeleton view till the stories are loaded. This attribute can be specified programmatically or from attributes inspector of design view.
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyGroupIconBackgroundColor = UIColor
```
    
In order to set this attribute from design view, change the color of the `Story Group Icon Background Color` under Storyly View section in attributes inspector.

#### ***Story Group Icon Border Color Seen (Multiple Colors):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen_1.png)

This attribute changes the border color of the story group icon which is already watched by the user. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used. This attribute can only be specified programmatically.
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyGroupIconBackgroundColor = [UIColor]
```
    

#### ***Story Group Icon Border Color Not Seen (Multiple Colors):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen_1.png)

This attribute changes the border color of the story group icon which has not watched by the user yet. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used. This attribute can only be specified programmatically.

In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyGroupIconBorderColorNotSeen = [UIColor]
```
    

#### ***Pinned Story Group Icon Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor_1.png)

If any of the story group is selected as pinned story from dashboard, a little icon will appear right bottom side of the story group. This attribute changes the background color of this little icon. This attribute can be specified programmatically or from attributes inspector of design view.
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyGroupPinIconColor = UIColor
```
    
In order to set this attribute from design view, change the color of the `Story Group Pin Icon Color` under Storyly View section in attributes inspector.

#### ***Story Item Text Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor_1.png)

This attribute changes the text color of the story item. This attribute can be specified programmatically or from attributes inspector of design view.
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyItemTextColor = UIColor
```
    
In order to set this attribute from design view, change the color of the `Story Item Text Color` under Storyly View section in attributes inspector.

#### ***Story Item Icon Border Color (Multiple Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar_1.png)

This attribute changes the border color of the story item icon. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used. This attribute can only be specified programmatically.
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyItemIconBorderColor = [UIColor]
```
    

#### ***Story Item Progress Bar Color (Two Colors):***
This attribute changes the colors of the progress bars. The bars consists of two colors.  The first defined color is the color of the background bars and the second one is the color of the foreground bars while watching the stories. This attribute can only be specified programmatically.
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.progressBarColor = [UIColor]
```
####  ***Story Group Size:***

This attribute changes the size of the story group. This attribute can be specified programmatically or from attributes inspector of design view. 
    
In order to set this attribute programmatically use the following method: 

```swift
storylyView.storyGroupSize = "small"
DEFAULT: storylyView.storyGroupSize = "large"
```
    
In order to set this attribute from design view, change the color of the `Story Group Size` under Storyly View section in attributes inspector.

## Advanced

* [Deep Links](advanced_docs/deep_linking.md)
* [Dynamic Segmentation](advanced_docs/dynamic_segmentation.md)
* [Storyly External Data Flow](advanced_docs/external_data.md)
