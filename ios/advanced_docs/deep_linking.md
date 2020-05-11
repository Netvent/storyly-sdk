### Deep Links

Storyly Dashboard generates a deep link with app's predefined custom scheme. Application needs to handle the setup of intent handling and route the uri to Storyly SDK to open the story. 

Application can determine from url's host if it's related with Storyly SDK, host will be 'storyly' for Storyly Dashboard generated deep link urls.

```swift
if deeplinkUrl.host.elementsEqual("storyly") {
    storylyView.openStory(payload: [DEEP_LINK_PAYLOAD_WITHOUT_SCHEME])
}
```
