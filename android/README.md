# Storyly 
Storyly SDK is used for story representation provided by App Samurai. You can register from [Storyly Dashboard](http://dashboard.storyly.io) and add stories to your registered applications and represent them in application with the help of this SDK.
Storyly SDK targets api level 17 or higher. 
## Getting Started
Storyly SDK is available through Maven.  To install
it, you can add dependency to application’s `build.gradle` file;
```
implementation 'com.appsamurai.storyly:storyly:0.0.1'
```
## Adding from XML
```xml
<com.appsamurai.storyly.StorylyView
    android:id="@+id/storyly_view"
    android:layout_width="match_parent"
    android:layout_height="100dp"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintTop_toTopOf="parent"
    android:layout_marginTop="8dp"
    android:layout_marginRight="8dp"
    android:layout_marginLeft="8dp"/>
```
## Initialization
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
}
```