# Release Notes
* These are Fabric supported versions of storyly-react-native, for the older architecture please use these [legacy versions](https://github.com/Netvent/storyly-mobile/blob/master/react-native/storyly-react-native-legacy/RELEASENOTES.md)

### 2.11.0 (09.01.2024)
* IMPORTANT! increased minimum os version to 12 on ios platform; please refer to [Xcode 15 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes)

### 2.10.0 (27.12.2023)
* improved data cache flow
* fixed a bug related to conditional stories flow
* added background image position/resize handling
* fixed IllegalStateException during activity recreation on android platform
* fixed a ui bug related to outlineProvider on android platform
* changed storyly-exoplayer2 dependency to 2.18.1-1 on android platform
* fixed a bug related to story group size on android platform

### 2.8.0 (18.12.2023)
* IMPORTANT! changed type of products parameter onProductHydration callback
* added nudge stories
* improved data update flow of story bar 
* fixed a bug related to conditional stories flow
* optimized memory management of SDWebImage on ios platform

### 2.7.0 (06.12.2023)
* improved codebase

### 2.6.0 (06.12.2023)
* IMPORTANT! added storylyLocale property for localization; please refer to [Localization documentation](https://docs.storyly.io/docs/ios-initial-sdk-setup#localization)
* IMPORTANT! removed storyProductCountry and storyProductLanguage properties; please use storylyLocale property
* added animation for not-fitting images in automated shoppable image layers
* added storyProductFeed property for client side automated shoppable stories
* improved story screen reset flow on android platform

### 2.5.2 (16.11.2023)
* improved story bar scrolling after data update
* changed storyId parameter to nullable for openStoryWithId function 
* fixed a bug related to group select on android platform

### 2.5.1 (09.11.2023)
* added improvements for text interactive components
* optimized story dismiss flow
* optimized memory usage on android platform
* fixed a visual bug in quiz interactive component on android platform
* fixed a visual bug in countdown interactive component on ios platform

### 2.5.0 (10.10.2023)
* IMPORTANT! migrated to [Fabric](https://reactnative.dev/architecture/fabric-renderer)