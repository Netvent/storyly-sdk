# Storyly External Data Flow
Storyly SDK enables application to set external data for predefined story group to fill on runtime.

You need to create a story group with specific source from Storyly Dashboard and pick a template for it. According to template's needs, application sets custom data in map format so that SDK can fill template and show rendered story to user.

## Usage
```swift
public func setExternalData(externalData: [[String: Any?]]?) -> Bool
```

```objc
public func setExternalData(externalData: [NSDictionary]?) -> Bool
```

External data is the list of mapping data for each story with predefined key-value pairing. 
For example, sample template consists of one image layer(key as template_image) and one text layer(key as template_text), external data should be at least as following;
```
[
    {
        "template_image": [CUSTOM_STORY_IMAGE_URL],
        "template_text": [CUSTOM_STORY_TEXT]
    },
    ...
]
```

Be aware that, application needs to call `setExternalData` after initialize `StorylyView`.

## Segmentify Case
Application can use [Segmentify](https://www.segmentify.com/) to fill template with personalized stories for each user. 

Please check [Segmentify iOS Integration](https://segmentify.github.io/segmentify-dev-doc/integration_ios/) for Segmentify usage.

Please note that, you need to create a story group with Segmentify as external source from Storyly Dashboard to use Segmentify. 

### Sample Usages
Storyly Dashboard templates for Segmentify consist of several layers; image layer to show image of product, text layer to show description of product, text layer to show price of product and button layer to handle user action.
```swift
func fetchSegmentifyData() {
    let customModel = CustomEventModel()
    customModel.type = "getSegmentifyRecommendation"
    SegmentifyManager.sharedManager().sendCustomEvent(segmentifyObject: customModel) { (responseModelList: [RecommendationModel]) in
        guard !responseModelList.isEmpty else {
            return
        }
        let externalData: [[String: Any?]]? = responseModelList[0].products?.compactMap { productRecommendationModel in
            var priceText = ""
            if let price = productRecommendationModel.price?.doubleValue,
                let currency = productRecommendationModel.params?["product_currency"] {
                priceText = "\(String(format: "%.2f", price)) \(currency)"
            }
            return [
                "action_url": productRecommendationModel.url,
                "image": productRecommendationModel.image,
                "description": productRecommendationModel.name,
                "price": priceText
            ]
        }
        _ = self.storylyView.setExternalData(externalData: externalData)
    }
}
```

This structure is valid for 2 Segmentify templates from Storyly Dashboard.