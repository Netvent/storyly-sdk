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
StorylyView can be added to storyboard and xib file by defining `Custom Class` as StorylyView in `Identity Inspector`. In this approach, setting `width` to device’s `width` and `height`  to 100 is suggested for better experience.
## Adding Programmatically
```swift
let storylyView = StorylyView()
        self.view.addSubview(storylyView)
        self.view.addConstraints([
            NSLayoutConstraint(item: storylyView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .top,
                               multiplier: 1,
                               constant: 10),
            NSLayoutConstraint(item: storylyView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .leading,
                               multiplier: 1,
                               constant: 8),
            NSLayoutConstraint(item: storylyView,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: -8),
            NSLayoutConstraint(item: storylyView,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: 100)
        ])
```
## Initialization
```swift
storylyView.appId = "[YOUR_APP_ID_FROM_DASHBOARD]"
storylyView.rootViewController = self // A view controller
storylyView.delegate = self // StorylyDelegate implementation
```