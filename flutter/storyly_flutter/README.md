# Storyly
Storyly SDK is used for story representation provided by App Samurai. You can register from [Storyly Dashboard](https://dashboard.storyly.io) and add stories to your registered applications and represent them in application with the help of this package.

Flutter plugin for Storyly. It's compatible with Android and iOS using PlatformView.
## Getting Started
### Android
Storyly SDK requires minimum API level 17, but PlatformView requires minimum API level 20. So, you need to update your app's minimum SDK version to 20. 

*Kotlin Support*

You need to set Kotlin plugin to Android App if it's not created by using Kotlin option. You can add this to app's main gradle file which is located in android/build.gradle.
```
buildscript {
    ext.kotlin_version = '1.4.30'
    ...
    dependencies {
        ...
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version'
        classpath 'org.jetbrains.kotlin:kotlin-serialization:$kotlin_version'
        ...
    }
}
```

Moreover, you need to check AndroidX support of your project. You can do this check and add related lines if it's required from android/gradle.properties file.
```
android.useAndroidX=true
android.enableJetifier=true
```
### iOS
Storyly SDK requires minimum iOS 9 version. 

You need to update pods of app, do not forget to run `pod update`. 

*PlatformView*

PlatformView's usage requires some updates on `Info.plist`, add following lines;

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

## Usage
### Import
Importing Storyly
```dart
import 'package:storyly_flutter/storyly_flutter.dart';
```
### Example
```dart
StorylyView(
    onStorylyViewCreated: onStorylyViewCreated,
    androidParam: StorylyParam()
    ..storylyId = [YOUR_APP_ID_FROM_DASHBOARD]
    ..storyGroupIconBorderColorSeen = [Color]
    ..storyGroupIconBorderColorNotSeen = [Color]
    ..storyGroupIconBackgroundColor = Color
    ..storyGroupTextColor = Color
    ..storyGroupPinIconColor = Color
    ..storyItemIconBorderColor = [Color]
    ..storyItemTextColor = Color
    ..storyItemProgressBarColor = [Color],
    iosParam: StorylyParam()
    ..storylyId = [YOUR_APP_ID_FROM_DASHBOARD]
    ..storyGroupIconBorderColorSeen = [Color]
    ..storyGroupIconBorderColorNotSeen = [Color]
    ..storyGroupIconBackgroundColor = Color
    ..storyGroupTextColor = Color
    ..storyGroupPinIconColor = Color
    ..storyItemIconBorderColor = [Color]
    ..storyItemTextColor = Color
    ..storyItemProgressBarColor = [Color],
    storylyLoaded: (storyGroupList) => print("storylyLoaded"),
    storylyLoadFailed: (errorMessage) => print("storylyLoadFailed"),
    storylyEvent: (eventPayload) => print("storylyEvent"),
    storylyActionClicked: (story) => print("storylyActionClicked"),
    storylyStoryShown: () => print("storylyStoryShown"),
    storylyStoryDismissed: () => print("storylyStoryDismissed")
    storylyUserInteracted: (eventPayload) => print("storylyUserInteracted"))
)
```

```dart
void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
    // You can call any function after this via StorylyViewController instance.
}
```

**storylyId** : It's required for your app's correct initialization.

## Storyly Events
In Storyly, there are 5 different optional methods that you can override and use.  These are:
* **storylyLoaded**: This function is called when your story groups are loaded without a problem. It informs about loaded story groups and stories in them. Check `storyGroupList` member of function parameter.
``` json
{
    "index":[int],
    "title":[string],
    "stories":[jsonarray of story]
}
```
* **storylyLoadFailed**: This function is called if any problem occurs while loading story groups such as network problem etc… You can find detailed information from `errorMessage` parameter.
* **storylyActionClicked**: This function is called when the user presses to action button on a story or swipes up in a story. You need to handle how the story link should be opened by overriding this method.
`storylyActionClicked` function has a parameter called `story`. It's json representation of `Story` object. You can check native documentation for paratemers in detail, also here is the sample format of parameters;
``` json
{
    "index":[int],
    "title":[string],
    "media":{
        "url":[string],
        "type":[int],
        "actionUrl":[string],
        "buttonText":[string],
        "data":{
            [string]:[string],
            [string]:[string],
            [string]:[string],
        }
    }
}
```
* **storylyStoryShown**: This method is called when a story is shown in fullscreen.
* **storylyStoryDismissed**: This method is called when story screen is dismissed.
* **storylyUserInteracted**: This method is called when a user is interacted with a quiz, a poll or an emoji. It contains json representation of `StoryComponent` object. You can check native documentation for paratemers in detail, also here is the sample format of parameters;
``` json
{
    "type":[string],
    // other details related to component, please check [Creating Story Component function for details](https://github.com/Netvent/storyly-mobile/blob/master/flutter/storyly_flutter/android/src/main/kotlin/com/appsamurai/storyly/storyly_flutter/FlutterStorylyView.kt#L192)
}
```
* **storylyEvent**: This method is called when a story event is occurred. It contains json representation of `StoryGroup`, `Story` and `StoryComponent` object in addition to `event` field. You can check native documentation for paratemers in detail, also here is the sample format of parameters;
``` json
{
    "event":[string],
    "storyGroup":[json],
    "story":[json],
    "storyComponent":[json]
}
```

## Storyly Methods
* **refresh**: You can call this function to refresh storyly view and load stories again.
* **storyShow**: You can call this function to show story screen if it's previously dismissed by app.
* **storyDismiss**: You can call this function to dismiss story screen.

## Storyly UI Customizations
Using Storyly SDK, you can customize story experience of your users. If you don’t specify any of these attributes, default values will be used. Some of the color related attributes are single color attributes and others require at least two colors.
Here is the list of attributes that you can change:
####  ***Story Group Text Color (Single Color):***
You need to set `storyGroupTextColor: Color` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor_1.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor.png)

This attribute changes the text color of the story group.
#### ***Story Group Icon Background Color (Single Color):***
You need to set `storyGroupIconBackgroundColor: Color` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground_1.png)

This attribute changes the background color of the story group icon which is shown to the user as skeleton view till the stories are loaded.
#### ***Story Group Icon Border Color Seen (Multiple Colors):***
You need to set `storyGroupIconBorderColorSeen: [Color]` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen_1.png)

This attribute changes the border color of the story group icon which is already watched by the user. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used.
#### ***Story Group Icon Border Color Not Seen (Multiple Colors):***
You need to set `storyGroupIconBorderColorNotSeen: [Color]` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen_1.png)

This attribute changes the border color of the story group icon which has not watched by the user yet. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used.
#### ***Pinned Story Group Icon Color (Single Color):***
You need to set `storyGroupPinIconColor: Color` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor_1.png)

If any of the story group is selected as pinned story from dashboard, a little icon will appear right bottom side of the story group. This attribute changes the background color of this little icon.
#### ***Story Item Text Color (Single Color):***
You need to set `storyItemTextColor: Color` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor_1.png)

This attribute changes the text color of the story item.
#### ***Story Item Icon Border Color (Multiple Color):***
You need to set `storyItemIconBorderColor: [Color]` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_iconborder.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_iconborder_1.png)

This attribute changes the border color of the story item icon. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used.
#### ***Story Item Progress Bar Color (Two Colors):***
You need to set `storyItemProgressBarColor: [Color]` parameter.
Default Sample:

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar.png)

Edited Sample:

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar_1.png)

This attribute changes the colors of the progress bars. The bars consists of two colors.  The first defined color is the color of the background bars and the second one is the color of the foreground bars while watching the stories.