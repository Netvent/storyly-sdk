# Storyly 
Storyly SDK is used for story representation provided by App Samurai. You can register from [Storyly Dashboard](http://dashboard.storyly.io) and add stories to your registered applications and represent them in application with the help of this SDK.

Storyly SDK targets api level 17 or higher. 
## Getting Started
Storyly SDK is available through Maven.  To install it, you must add the following dependency to application’s `build.gradle` file, be sure to use the latest version which is: [ ![Download](https://api.bintray.com/packages/appsamurai/maven/attribution/images/download.svg) ](https://bintray.com/appsamurai/maven/storylly/_latestVersion).
```
implementation ‘com.appsamurai.storyly:storyly:<latest-version>'
```
## Adding from XML
```xml
<com.appsamurai.storyly.StorylyView
    android:id="@+id/storyly_view"
    android:layout_width="match_parent"
    android:layout_height=“120dp”
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintTop_toTopOf="parent"
    android:layout_marginTop=“8dp”/>
```
## Initialization
Kotlin:
```kotlin
storyly_view.storylyId = "[YOUR_APP_ID_FROM_DASHBOARD]"
storyly_view.storylyListener = object: StorylyListener{
    override fun storylyLoaded(storylyView: StorylyView) {
        super.storylyLoaded(storylyView)
        Log.d("[Storyly]", "storylyLoaded")
    }

    override fun storylyLoadFailed(storylyView: StorylyView) {
        super.storylyLoadFailed(storylyView)
        Log.d("[Storyly]", "storylyLoadFailed")
    }

    // return true if app wants to handle redirection, otherwise return false
    override fun storylyActionClicked( storylyView: StorylyView, story: Story): Boolean {
        Log.d("[Storyly]", "storylyActionClicked")
		  return false
    }
}
```
Java:
```java
StorylyView storylyView = findViewById(R.id.storyly_view);
storylyView.setStorylyId("[YOUR_APP_ID_FROM_DASHBOARD]");
storylyView.setStorylyListener(new StorylyListener() {
    @Override
    public void storylyLoaded(@NonNull StorylyView storylyView) {
        Log.d("[Storyly]", "storylyLoaded");
    }

    @Override
    public void storylyLoadFailed(@NonNull StorylyView storylyView) {
        Log.d("[Storyly]", "storylyLoadFailed");
    }

    // return true if app wants to handle redirection, otherwise return false
    @Override
    public boolean storylyActionClicked(@NonNull StorylyView storylyView, @NonNull Story story) {
         Log.d("[Storyly]", "storylyActionClicked");
         return false;
    }
});
```

If you are planning to do additional operations with the story link by overriding `storylyActionClicked`method, you can access the link by using `story.media.actionUrl`.
## Refresh
Kotlin:
```kotlin
storyly_view.refresh()
```
Java: 
```java
StorylyView storylyView = findViewById(R.id.storyly_view);
…
storylyView.refresh();
```
## UI Customizations
Using Storyly SDK, you can customize story experience of your users. If you don’t specify any of these attributes, default values will be used. Some of color related attributes are single color attributes and others requires at least two colors. 

In order to specify the attributes in layout xml, following part should be added as layout attribute:
```xml
xmlns:app=“http://schemas.android.com/apk/res-auto”
```

Here is the list of attributes that you can change:
##### ***Story Group Text Color (Single Color):***
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
app:storyGroupTextColor=“@android:color/<color>”
or
app:storyGroupTextColor=“#RGBA”
```

In order to set this attribute from design view, find and fill the `storyGroupTextColor` attribute.


#####  ***Story Group Icon Background Color (Single Color):***
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
app:storyGroupIconBackgroundColor=“@android:color/<color>”
or
app:storyGroupIconBackgroundColor=“#RGBA”
```

In order to set this attribute from design view, find and fill the `storyGroupIconBackgroundColor` attribute.


#####  ***Story Group Icon Border Color Seen (Multiple Colors):***
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
<array name=“seen”>
    <item>#FFDBDBDB</item>
    <item>#FFDBDBDB</item>
</array>
```

```xml
app:storyGroupIconBorderColorSeen=“@<location>/seen”
```

In order to set this attribute from design view, find and fill the `storyGroupIconBorderColorSeen` attribute as an array of color codes.

##### ***Story Group Icon Border Color Not Seen (Multiple Colors):***
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
<array name=“notSeen”>
    <item>#FFFED169</item>
    <item>#FFFA7C20</item>
    <item>#FFC9287B</item>
    <item>#FF962EC2</item>
    <item>#FFFED169 </item>
</array>
```

```xml
app:storyGroupIconBorderColorNotSeen=“@<location>/notSeen”
```

In order to set this attribute from design view, find and fill the `storyGroupIconBorderColorNotSeen` attribute as an array of color codes.

##### ***Pinned Story Group Icon Color (Single Color):***
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
app:storyGroupPinIconColor=“@android:color/<color>”
or
app:storyGroupPinIconColor=“#RGBA”
```

In order to set this attribute from design view, find and fill the `storyGroupPinIconColor` attribute.

##### ***Story Item Text Color (Single Color):***
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
app:storyItemTextColor=“@android:color/<color>”
or
app:storyItemTextColor=“#RGBA”
```

In order to set this attribute from design view, find and fill the `storyItemTextColor` attribute.

##### ***Story Item Icon Border Color (Multiple Color):***
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
<array name=“storyItemBorderColors”>
    <item>#FFDBDBDB</item>
    <item>#FFDBDBDB</item>
</array>
```

```xml
app:storyItemIconBorderColor=“@<location>/storyItemBorderColors”
```

In order to set this attribute from design view, find and fill the `storyItemIconBorderColor` attribute as an array of color codes.

##### ***Story Item Progress Bar Color (Two Colors):***
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
<array name=“progressBarColors”>
    <item>#CCCCCCCC</item>
    <item>#FFFFFFFF</item>
</array>
```

```xml
app:storyItemProgressBarColor=“@<location>/progressBarColors”
```

In order to set this attribute from design view, find and fill the `storyItemProgressBarColor` attribute as an array of color codes.
