import StorylyCore
import StorylyCanvas


func encodeCanvasDataPayload(_ data: CanvasDataPayload) -> [String: Any] {
    return [
        "type": STRWidgetType.canvas.description,
        "items": data.items.map { encodeCanvasItem($0) }
    ]
}

func encodeCanvasPayload(_ payload: CanvasPayload?) -> [String: Any]? {
    guard let payload = payload else { return nil }
    
    return [
        "item": encodeCanvasItem(payload.item)
    ].compactMapValues { $0 }
}

func encodeCanvasItem(_ item: CanvasItem?) -> [String: Any?]? {
  guard let item = item else { return nil }
  return [
    "actionUrl": item.actionUrl,
    "actionProducts": item.actionProducts?.map { encodeSTRProductItem($0) }
  ]
}
