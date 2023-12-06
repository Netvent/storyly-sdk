# Release Notes
* These are Fabric supported versions of storyly-react-native, for the older architecture please use these [legacy versions](https://github.com/Netvent/storyly-mobile/blob/master/react-native/storyly-react-native-legacy/RELEASENOTES.md)

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