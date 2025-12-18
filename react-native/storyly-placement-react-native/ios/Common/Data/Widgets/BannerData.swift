import Foundation
import StorylyCore
import StorylyBanner

// MARK: - Banner Data Payload Encoding

func encodeBannerDataPayload(_ data: BannerDataPayload) -> [String: Any] {
    return [
        "type": STRWidgetType.banner.description,
        "items": data.items.map { encodeBannerSlide($0) }.compactMap { $0 }
    ]
}

func encodeBannerPayload(_ payload: BannerPayload?) -> [String: Any]? {
    guard let payload = payload else { return nil }
    
    return [
        "component": encodeBannerComponent(payload.component),
        "item": encodeBannerSlide(payload.item)
    ].compactMapValues { $0 }
}

// MARK: - Banner Slide Encoding

func encodeBannerSlide(_ slide: BannerSlide?) -> [String: Any]? {
    guard let slide = slide else { return nil }
    
    return ([
        "id": slide.uniqueId,
        "name": slide.name,
        "index": slide.index,
        "actionUrl": slide.actionUrl,
        "componentList": slide.componentList?.map { encodeBannerComponent($0) }.compactMap { $0 },
        "actionProducts": slide.actionProducts?.map { encodeSTRProductItem($0) },
        "currentTime": slide.currentTime
    ]  as [String: Any?]).compactMapValues { $0 }
}

// MARK: - Banner Component Encoding

func encodeBannerComponent(_ component: BannerComponent?) -> [String: Any]? {
    guard let component = component else { return nil }
    
    var result: [String: Any] = [
        "id": component.id,
        "type": component.type.get(),
        "customPayload": component.customPayload as Any
    ]
    
    if let button = component as? BannerButtonComponent {
        result["text"] = button.text
        result["actionUrl"] = button.actionUrl
        result["products"] = button.products?.map { encodeSTRProductItem($0) }
    }
    
    return result.compactMapValues { $0 }
}


