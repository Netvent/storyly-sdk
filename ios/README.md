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
StorylyView can be added to storyboard and xib file by defining `Custom Class` as StorylyView in `Identity Inspector`. In this approach, setting `width` to device’s `width` and `height`  to 120 is suggested for better experience.
## Adding Programmatically
```swift
let storylyView = StorylyView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 120))
self.view.addSubview(storylyView)
```
## Initialization
```swift
storylyView.appId = "[YOUR_APP_ID_FROM_DASHBOARD]"
storylyView.rootViewController = self // A view controller
storylyView.delegate = self // StorylyDelegate implementation
```
## Refresh
```swift
storylyView.refresh()
```
 
## Storyly Events
In Storyly, there are 3 different optional methods that you can use in an extension.  These are:
* storylyLoaded: This method is called when your story groups are loaded without a problem.
* storylyLoadFailed: This method is called if any problem occurs while loading story groups such as network problem etc…
* storylyActionClicked: This method is called when the user clicks to action button on a story or swipes up in a story.  If you want to handle how the story link should be opened, you should override this method and you must return true as a result. Otherwise, SDK will open the link in a new activity. 

Sample usages can be seen below:
```swift
extension ViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView) {
        print(“storylyLoaded”)
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, error: StorylyError) {
        print(“storylyLoadFailed \(error.localizedDescription)”)
    }

    // return true if app wants to handle redirection, otherwise return false
    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) -> Bool {
        print(“storylyActionClicked \(story)”)
        return true
    }
}
```
As it can be seen from `storylyActionClicked` method, there is an object called `Story`. This object represents the story in which action is done and has some information about the story to be used. The structure of the `Story`, `StoryMedia`, `StorylyData` and `StoryType` objects are as follows:

```swift
@objc public enum StoryType: Int {
    case Unknown
    case Image
    case Video
    case HTML
}

@objc public final class Story: NSObject {
    @objc public let index: Int
    @objc public let title: String
    @objc public let media: StoryMedia
}

@objc public final class StoryMedia: NSObject {
    @objc public let type: StoryType
    @objc public let url: URL
    @objc public let buttonText: String
    @objc public var data: [StorylyData]?
    @objc public var actionUrl: String
}

@objc public final class StorylyData: NSObject {
    @objc public let key: String
    @objc public let value: String
}
``` 

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
	
