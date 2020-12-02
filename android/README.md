# Storyly 
Storyly SDK is used for story representation provided by App Samurai. You can register from [Storyly Dashboard](http://dashboard.storyly.io) and add stories to your registered applications and represent them in application with the help of this SDK.

Storyly SDK targets api level 17 or higher. 
## Getting Started
Storyly SDK is available through Maven.  To install it, you must add the following dependency to application’s `build.gradle` file, be sure to use the latest version which is: [ ![Download](https://api.bintray.com/packages/appsamurai/maven/storyly/images/download.svg) ](https://bintray.com/appsamurai/maven/storyly/_latestVersion).
```
implementation 'com.appsamurai.storyly:storyly:<latest-version>'
```
## Adding from XML
```xml
<com.appsamurai.storyly.StorylyView
    android:id="@+id/storyly_view"
    android:layout_width="match_parent"
    android:layout_height="120dp"/>
```
## Initialization
Kotlin:
```kotlin
storyly_view.storylyInit = StorylyInit([YOUR_APP_TOKEN_FROM_SETTINGS_SECTION_IN_DASHBOARD])
```
Java:
```java
storylyView.setStorylyInit(new StorylyInit([YOUR_APP_TOKEN_FROM_SETTINGS_SECTION_IN_DASHBOARD], new StorylySegmentation()));
```

## Storyly Initialization Parameters
Storyly can be customized based on your initialization parameters. Currently, StorylyInit data class has the following definition:
```kotlin
data class StorylyInit(
    internal val storylyId: String,
    internal val segmentation: StorylySegmentation = StorylySegmentation()
    internal var customParameter: String? = null
)
```

#### Storyly Label Parameters
In StorylyInit class, "labels" parameter is related with the story group labels. In your storyly dashboard, if you set labels for your story groups you can use this parameter to filter these story groups. If label of the group group in dashboard is subset of your labels in SDK, SDK will show that story group. Here are a few examples: 
- If you do not give any parameters to labels, SDK will show all active story groups with/without labels. This is the default behaviour.
- If you set ["car", "man"] as label set in SDK, Storyly SDK will show the story groups whose label set is "car", "man", car" and "man" and lastly it will show the story groups without labels. 
- If you set an empty label set in SDK, only the story groups without labels will be shown.

StorylySegmentation has the following method constructor:
```kotlin
class StorylySegmentation(segments: Set<String>? = null,
                                internal val isDynamicSegmentationEnabled: Boolean = false,
                                dynamicSegmentationCallback: (StorylyDynamicSegmentationCallback? = null) 
```
It is enough to set labels parameter to use label feature. All labels in SDK are case insensitive and trimmed. 

If you want to get information about what other parameters are please check Dynamic Label in [Advanced](#advanced) section.

#### Custom Parameter
In StorylyInit class, "customParameter" field can be used for analytical purposes. You can send a string value with this field which cannot have more than 200 characters. If you exceed the size limit, your value will be set to nil.

## Storyly Events
In Storyly, there are 5 different optional methods that you can override and use.  These are:
* storylyLoaded: This method is called when your story groups are loaded without a problem. It informs about loaded story groups and stories in them.
* storylyLoadFailed: This method is called if any problem occurs while loading story groups such as network problem etc… You can find detailed information from `errorMessage` parameter.
* storylyActionClicked: This method is called when the user clicks to action button on a story or swipes up in a story.  If you want to handle how the story link should be opened, you should override this method and you must return true as a result. Otherwise, SDK will open the link in a new activity. 
* storylyStoryShown: This method is called when a story is shown in fullscreen.
* storylyStoryDismissed: This method is called when story screen is dismissed.
* storylyUserInteracted: This method is called when a user is interacted with a quiz, a poll or an emoji.
Sample usages can be seen below:

Kotlin:
```kotlin
storyly_view.storylyListener = object: StorylyListener{
    override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {}

    override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {}

    // return true if app wants to handle redirection, otherwise return false
    override fun storylyActionClicked( storylyView: StorylyView, story: Story): Boolean {
          return true
    }

    override fun storylyStoryShown(storylyView: StorylyView) {}

    override fun storylyStoryDismissed(storylyView: StorylyView) {}
    
    //StoryComponent can be one of the following subclasses: StoryEmojiComponent, StoryQuizComponent, StoryPollComponent. 
    //Based on "type" property of storyComponent, cast this argument to the proper subclass
    override fun storylyUserInteracted(storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {}
}
```
Java:
```java
storylyView.setStorylyListener(new StorylyListener() {
    @Override
    ppublic void storylyLoaded(@NonNull StorylyView storylyView, @NonNull List<StoryGroup> storyGroupList) {}

    @Override
    public void storylyLoadFailed(@NonNull StorylyView storylyView, @NonNull String errorMessage) {}

    // return true if app wants to handle redirection, otherwise return false
    @Override
    public boolean storylyActionClicked(@NonNull StorylyView storylyView, @NonNull Story story) {
         return true;
    }

    @Override
    public void storylyStoryShown(@NonNull StorylyView storylyView) {}

    @Override
    public void storylyStoryDismissed(@NonNull StorylyView storylyView) {}
    
    //StoryComponent can be one of the following subclasses: StoryEmojiComponent, StoryQuizComponent, StoryPollComponent. 
    //Based on "type" property of storyComponent, cast this argument to the proper subclass
    @Override
    public void storylyUserInteracted(@NonNull StorylyView storylyView, @NonNull StoryGroup storyGroup, @NonNull Story story, @NonNull StoryComponent storyComponent) {}

});
```

As it can be seen from `storylyActionClicked` method, there is an object called `Story`. This object represents the story in which action is done and has some information about the story to be used. The structure of the `Story`, `StoryMedia`, `StorylyData` and `StoryType` objects can be seen below. In addition, `storylyUserInteracted` method has a parameter called `StoryComponent` which has the following subclasses `StoryQuizComponent`, `StoryEmojiComponent`, `StoryPollComponent` with type class `StoryComponentType`, details of these object also can be seen below:

```kotlin
data class StoryGroup(
    val id: Int,
    val title: String,
    val iconUrl: String,
    val index: Int,
    val stories: List<Story>
)

data class Story(
    val id: Int,
    val title: String,
    val index: Int,
    val media: StoryMedia
)

data class StoryMedia(
    val type: StoryType,
    val url: String,
    val buttonText: String,
    val data: List<StorylyData>?
    val actionUrl: String
)

data class StoryData(
    val key: String,
    val value: String
)

enum class StoryType {
    Unknown,
    Image,
    Video;
}

@Keep
open class StoryComponent(val type: StoryComponentType)

@Keep
enum class StoryComponentType {
    Quiz,
    Poll,
    Emoji;
}

@Keep
data class StoryQuizComponent(
    val title: String,
    val options: List<String>,
    val rightAnswerIndex: Int?,
    val selectedOptionIndex: Int,
    val customPayload: String?
): StoryComponent(StoryComponentType.Quiz)

@Keep
data class StoryPollComponent(
    val title: String,
    val options: List<String>,
    val selectedOptionIndex: Int,
    val customPayload: String?
): StoryComponent(StoryComponentType.Poll)

@Keep
data class StoryEmojiComponent(
    val emojiCodes: List<String>,
    val selectedEmojiIndex: Int,
    val customPayload: String?
): StoryComponent(StoryComponentType.Emoji)
``` 

Kotlin:
```kotlin
storyly_view.show()
```
Java: 
```java
storylyView.show();
```

## Refresh
Kotlin:
```kotlin
storyly_view.refresh()
```
Java: 
```java
storylyView.refresh();
```

## Third Party Library Integrations
In Storyly, you can use different story templates to show personalized products to your users if you are using one of the following personalization platforms. Currently, [Segmentify](https://www.segmentify.com/) is supported. Please check `Storyly External Data Flow` in [Advanced](#advanced) section in order to learn how to use these third party libraries.

#### Segmentify:
If you are planning to use Segmentify story group, please make sure you initialize Segmentify before Storyly initialization. Then, you can create different template stories from dashboard which has a Segmentify source. For more details on Segmentify integration: https://segmentify.github.io/segmentify-dev-doc/integration_android/

## UI Customizations
Using Storyly SDK, you can customize story experience of your users. If you don’t specify any of these attributes, default values will be used. Some of the color related attributes are single color attributes and others require at least two colors. 

In order to specify the attributes in layout xml, following part should be added as layout attribute:
```xml
xmlns:app="http://schemas.android.com/apk/res-auto"
```

Here is the list of attributes that you can change:
####  ***Story Group Text Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor_1.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_textcolor.png)

This attribute changes the text color of the story group. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryGroupTextColor(color: Int)
```
Java:
```java
    storylyView.setStoryGroupTextColor(Int color)
```
    
In order to set this attribute from layout xml add the following attribute as StorylyView attribute:

```xml
app:storyGroupTextColor="@android:color/<color>"
or
app:storyGroupTextColor="#RGBA"
```

In order to set this attribute from design view, find and fill the `storyGroupTextColor` attribute.


#### ***Story Group Icon Background Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_iconbackground_1.png)

This attribute changes the background color of the story group icon which is shown to the user as skeleton view till the stories are loaded. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryGroupIconBackgroundColor(color: Int)
```
Java:
```java
    storylyView.setStoryGroupIconBackgroundColor(Int color)
```
    
In order to set this attribute from layout xml add the following attribute as StorylyView attribute:

```xml
app:storyGroupIconBackgroundColor="@android:color/<color>"
or
app:storyGroupIconBackgroundColor="#RGBA"
```

In order to set this attribute from design view, find and fill the `storyGroupIconBackgroundColor` attribute.


#### ***Story Group Icon Border Color Seen (Multiple Colors):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_seen_1.png)

This attribute changes the border color of the story group icon which is already watched by the user. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryGroupIconBorderColorSeen(colors: Array<Int>)
```
Java:
```java
    storylyView.setStoryGroupIconBorderColorSeen(Integer[] color)
```
    
In order to set this attribute from layout xml, first define an array of color code items as a resource and then give the name of the array as reference as a StorylyView attribute:

```xml
<array name="seen">
    <item>#FFDBDBDB</item>
    <item>#FFDBDBDB</item>
</array>
```

```xml
app:storyGroupIconBorderColorSeen="@<location>/seen"
```

In order to set this attribute from design view, find and fill the `storyGroupIconBorderColorSeen` attribute as an array of color codes.

#### ***Story Group Icon Border Color Not Seen (Multiple Colors):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_notseen_1.png)

This attribute changes the border color of the story group icon which has not watched by the user yet. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryGroupIconBorderColorNotSeen(colors: Array<Int>)
```
Java:
```java
    setStoryGroupIconBorderColorNotSeen(Integer[] color)
```
    
In order to set this attribute from layout xml, first define an array of color code items as a resource and then give the name of the array as reference as a StorylyView attribute:

```xml
<array name="notSeen">
    <item>#FFFED169</item>
    <item>#FFFA7C20</item>
    <item>#FFC9287B</item>
    <item>#FF962EC2</item>
    <item>#FFFED169 </item>
</array>
```

```xml
app:storyGroupIconBorderColorNotSeen="@<location>/notSeen"
```

In order to set this attribute from design view, find and fill the `storyGroupIconBorderColorNotSeen` attribute as an array of color codes.

#### ***Pinned Story Group Icon Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/sg_pincolor_1.png)

If any of the story group is selected as pinned story from dashboard, a little icon will appear right bottom side of the story group. This attribute changes the background color of this little icon. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryGroupPinIconColor(color: Int)
```
Java:
```java
    storylyView.setStoryGroupPinIconColor(Int color)
```
    
In order to set this attribute from layout xml add the following attribute as StorylyView attribute:

```xml
app:storyGroupPinIconColor="@android:color/<color>"
or
app:storyGroupPinIconColor="#RGBA"
```

In order to set this attribute from design view, find and fill the `storyGroupPinIconColor` attribute.

#### ***Story Item Text Color (Single Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_textcolor_1.png)

This attribute changes the text color of the story item. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryItemTextColor(color: Int)
```
Java:
```java
    storylyView.setStoryItemTextColor(Int color)
```
    
In order to set this attribute from layout xml add the following attribute as StorylyView attribute:

```xml
app:storyItemTextColor="@android:color/<color>"
or
app:storyItemTextColor="#RGBA"
```

In order to set this attribute from design view, find and fill the `storyItemTextColor` attribute.

#### ***Story Item Icon Border Color (Multiple Color):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_iconborder.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_iconborder_1.png)

This attribute changes the border color of the story item icon. The border consists of color gradients. At least 2 colors must be defined in order to use this attribute. If a single color is requested,  two same color code can be used. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryItemIconBorderColor(colors: Array<Int>)
```
Java:
```java
    storylyView.setStoryItemIconBorderColor(Integer[] color)
```
    
In order to set this attribute from layout xml, first define an array of color code items as a resource and then give the name of the array as reference as a StorylyView attribute:

```xml
<array name="storyItemBorderColors">
    <item>#FFDBDBDB</item>
    <item>#FFDBDBDB</item>
</array>
```

```xml
app:storyItemIconBorderColor="@<location>/storyItemBorderColors"
```

In order to set this attribute from design view, find and fill the `storyItemIconBorderColor` attribute as an array of color codes.

#### ***Story Item Progress Bar Color (Two Colors):***

Default Sample: 

![Default Group Text](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar.png) 

Edited Sample: 

![Example](https://github.com/Netvent/storyly-mobile/blob/master/readme_images/si_progressbar_1.png)

This attribute changes the colors of the progress bars. The bars consists of two colors.  The first defined color is the color of the background bars and the second one is the color of the foreground bars while watching the stories. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryItemProgressBarColor(colors: Array<Int>)
```
Java:
```java
    storylyView.setStoryItemProgressBarColor(Integer[] color)
```
    
In order to set this attribute from layout xml, first define an array of color code items as a resource and then give the name of the array as reference as a StorylyView attribute:

```xml
<array name="progressBarColors">
    <item>#CCCCCCCC</item>
    <item>#FFFFFFFF</item>
</array>
```

```xml
app:storyItemProgressBarColor="@<location>/progressBarColors"
```

In order to set this attribute from design view, find and fill the `storyItemProgressBarColor` attribute as an array of color codes.

####  ***Story Group Size:***

This attribute changes the size of the story group. This attribute can be specified programmatically, from layout xml or from attributes section of design view. 
    
In order to set this attribute programmatically use the following method: 

Kotlin:
```kotlin
    storylyView.setStoryGroupSize(size: StoryGroupSize)
```
Java:
```java
    storylyView.setStoryGroupSize(StoryGroupSize size)
```
    
In order to set this attribute from layout xml add the following attribute as StorylyView attribute:

```xml
app:storyGroupSize="small"
or
DEFAULT: app:storyGroupSize="large"
```

In order to set this attribute from design view, find and fill the `storyGroupSize` attribute.

####  ***Story Group Icon Styling (Just valid for `Custom` story group size):***

This styling changes the shape of the story group icons, their corners and the distance between each other. Users can create square, circle and oval shaped icons using these attributes. In order to use these values, your group size should be set to `custom`. Otherwise, they will not affect the story groups. This styling can be specified programmatically, from layout xml or from attributes section of design view. Users should set `StoryGroupIconStyling` data class which consists of the following variables: height, width, cornerRadius and paddingBetweenItems. 

In order to set this styling programmatically use the following method: 
Kotlin:
```kotlin
    storylyView.setStoryGroupIconStyling(storyGroupIconStyling: StoryGroupIconStyling)
```
Java:
```java
    storylyView.setStoryGroupIconStyling(StoryGroupIconStyling storyGroupIconStyling)
```
If you will set the values programmatically, you should send the pixel values for the variables of StoryGroupIconStyling.

If you are planning to set this styling from layout xml add the following attributes as StorylyView attributes:

```xml
app:storyGroupIconHeight="" (should be set as dp, default values is: "80dp")
app:storyGroupIconWidth="" (should be set as dp, default values is: "80dp")
app:storyGroupIconCornerRadius="" (should be set as dp, default values is: "40dp")
app:storyGroupPaddingBetweenItems="" (should be set as dp, default values is: "4dp")
```

####  ***Story Group Text Styling:***

This styling changes the visibility of the story group text. This styling can be specified programmatically, from layout xml or from attributes section of design view. Users should set `StoryGroupTextStyling` data class which consists of the following variable: isVisible. 

In order to set this styling programmatically use the following method: 
Kotlin:
```kotlin
    storylyView.setStoryGroupTextStyling(storyGroupTextStyling: StoryGroupTextStyling)
```
Java:
```java
    storylyView.setStoryGroupTextStyling(StoryGroupTextStyling storyGroupTextStyling)
```

If you are planning to set this styling from layout xml add the following attributes as StorylyView attribute:

```xml
app:storyGroupTextIsVisible="" (boolean, default values is: "true")
```

####  ***Story Header Styling:***

This styling changes the visibility of the text and icon of the stories. This styling can be specified programmatically, from layout xml or from attributes section of design view. Users should set `StoryHeaderStyling` data class which consists of the following variables: isTextVisible, isIconVisible. 

In order to set this styling programmatically use the following method: 
Kotlin:
```kotlin
    storylyView.setStoryHeaderStyling(storyHeaderStyling: StoryHeaderStyling)
```
Java:
```java
    storylyView.setStoryHeaderStyling(StoryHeaderStyling storyHeaderStyling)
```

If you are planning to set this styling from layout xml add the following attributes as StorylyView attributes:

```xml
app:storyHeaderIconIsVisible="" (boolean, default values is: "true")
app:storyHeaderTextIsVisible="" (boolean, default values is: "true")
```

## Advanced

* [Deep Links](advanced_docs/deep_linking.md)
* [Dynamic Segmentation](advanced_docs/dynamic_segmentation.md)
* [Storyly External Data Flow](advanced_docs/external_data.md)
