# Release Notes
### 4.3.0 (11.11.2024)
* IMPORTANT! renamed products field to actionProducts in Story class
* IMPORTANT! renamed products field to actionProducts in VerticalFeedItem class
* IMPORTANT! renamed resume function to play in StorylyVerticalFeedPresenterView
* IMPORTANT! renamed products field to actionProducts in Story class
* added vertical feed
* improved vertical feed design
* added vertical feed presenter view
* added new public interactive component types for Storyly and VerticalFeed
* added like animation in vertical feed 
* refactor initialization of vertical feed
* fixed a few bugs related to vertical feed image carousel
* changed play/pause handling of vertical feed for StorylyVerticalFeedPresenterView
* improved synchronization between video story media and header
* improved AVAudioSession category changes
* improved present function of StorylyViewController
* changed modifier of storylyId in StorylyInit
* improved memory usage of gif media

### 3.6.0 (09.09.2024)
* added story bar instance settings
* fixed bug related to interactive component interaction

### 3.4.0 (29.07.2024)
* added out of stock handling for product related interactive components

### 3.3.0 (29.07.2024)
* added video covers for story groups
* fixed instagram store id for share sheet

### 3.2.1 (22.07.2024)
* improved storyly widget related analytic events
* improved story group visibility related analytic events
* improved missing monetization fields handling
* improved story share handling for missing social apps
* changed logo and text of Twitter to X on share sheet

### 3.2.0 (01.07.2024)
* added sponsored story group feature

### 3.1.0 (13.06.2024)
* improved story group cover selection flow with focal points
* improved missing product handling by filtering stories

### 3.0.0 (24.05.2024)
* improved load time of the Storyly Widget
* IMPORTANT! removed StoryMedia class and media field from public Story class
* IMPORTANT! added previewUrl, actionUrl and storyComponentList to the public Story class

### 2.18.1 (24.05.2024)
* added key field for product variants to indicate variant type

### 2.18.0 (13.05.2024)
* improved placement of product tag interactive component based on content
* improved payload of product events
* fixed storylyStoryDismissed delegate trigger time

### 2.17.3 (06.05.2024)
* improved usage of actionUrl and products in storylyActionClicked callback

### 2.17.2 (25.04.2024)
* fixed a bug related to analytics requests

### 2.17.1 (24.04.2024)
* fixed thumbnail image load issue of video stories
* fixed story dismiss issue after a non-modal view controller presented over stories

### 2.17.0 (08.04.2024)
* fixed RTL support issues for product related interactive components
* fixed bugs related to conditional stories
* added additional bottom sheet customizations for product related interactive components
* improved bottom sheet functionality for product related interactive components
* improved StorylyDataSource by simplifying the sources for storylyLoaded callback
* added privacy manifest files for the upcoming SDK requirements

### 2.16.1 (19.03.2024)
* improved price formatting for product related interactive components
* fixed a bug related to interactive component representation
* improved action flow for product related interactive components
* improved analytic events

### 2.15.0 (27.02.2024)
* improved media url handling
* improved functionality of product catalog interactive component
* fixed a bug related to product cart state

### 2.14.0 (20.02.2024)
* added animations for text interactive component
* improved functionality and design of story group countdown badge
* fixed a bug related to scroll position in storyly bar on android platform
* fixed an orientation bug for devices having iOS version <16 on ios platform

### 2.12.1 (19.01.2024)
* fixed an orientation bug for devices having iOS version <16

### 2.12.0 (12.01.2024)
* added video position/resize handling
* added static inputs for product catalog interactive component
* improved data processing flow
* fixed a simulator architecture bug for cocoapods

### 2.11.0 (09.01.2024)
* IMPORTANT! increased minimum os version to 12; please refer to [Xcode 15 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes)

### 2.10.0 (27.12.2023)
* improved data cache flow
* fixed a bug related to conditional stories flow
* added background image position/resize handling

### 2.8.0 (18.12.2023)
* added product related config and APIs
* added custom styling for story groups
* added nudge stories
* improved data update flow of story bar 
* fixed a bug related to conditional stories flow
* optimized memory management of SDWebImage
